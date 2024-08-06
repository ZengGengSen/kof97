target := kof97

include Makefile.config

all:
	$(MAKE) -C assets all
	$(MAKE) -C ngdevkit/nullbios all
	$(MAKE) -C ngdevkit/nullsound all
	$(MAKE) -C ngdevkit/runtime all
	$(MAKE) -C $(target) all

clean:
	$(MAKE) -C $(target) clean
	$(MAKE) -C ngdevkit/runtime clean
	$(MAKE) -C ngdevkit/nullsound clean
	$(MAKE) -C ngdevkit/nullbios clean
	$(MAKE) -C assets clean

gngeo:
	$(MAKE) -C $(target) gngeo

# include Makefile.common

# ngdevkit-gngeo config targets
all: build-gngeo-config

define GNGEO_DEFAULT_INPUT_SETTINGS =
# default blitter
blitter $(if $(findstring yes,$(GNGEO_GLSL)),glsl,soft)
$(if $(and $(findstring yes,$(GNGEO_GLSL)),$(if $(findstring yes,$(ENABLE_MINGW)),,nomingw)),shaderpath $(SHADER_PATH),)
$(if $(findstring yes,$(GNGEO_GLSL)),shader $(SHADER),)

# default scale factor
scale 3

# default key mapping
p1control A=K97,B=K115,C=K113,D=K119,START=K49,COIN=K51,UP=K82,DOWN=K81,LEFT=K80,RIGHT=K79,A=J0B0,B=J0B1,C=J0B2,D=J0B3,START=J0B9,COIN=J0B8,UP=J0a3,DOWN=J0a3,LEFT=J0A0,RIGHT=J0A0
p2control A=K103,B=K104,C=K116,D=K117,START=K50,COIN=K52,UP=K105,DOWN=K107,LEFT=K106,RIGHT=K108,A=J1B0,B=J1B1,C=J1B2,D=J1B3,START=J1B9,COIN=J1B8,UP=J1a3,DOWN=J1a3,LEFT=J1A0,RIGHT=J1A0
endef

ifeq ($(ENABLE_MINGW),yes)
GNGEO_CFG=$(GNGEO_INSTALL_PATH)/conf/ngdevkit-gngeorc
else
ifeq ($(ENABLE_MSYS2),yes)
GNGEO_CFG=$(shell cygpath $(HOMEDRIVE)$(HOMEPATH))/.gngeo/ngdevkit-gngeorc
else
GNGEO_CFG=$(HOME)/.gngeo/ngdevkit-gngeorc
endif
endif

build-gngeo-config: $(GNGEO_CFG)

$(GNGEO_CFG): export INPUT_SETTINGS:=$(GNGEO_DEFAULT_INPUT_SETTINGS)
$(GNGEO_CFG):
	@ echo generating a default input config for gngeo; \
	mkdir -p $(dir $(GNGEO_CFG)) && \
	echo "$$INPUT_SETTINGS" > $(GNGEO_CFG)



# ngdevkit-gngeo shaders when running under mingw
ifeq ($(ENABLE_MINGW),yes)
ifneq ($(SHADER),)
ifneq ($(SHADER),noop.glslp)
ifneq ($(GLSL_SHADER_PATH),)
all: copy-gngeo-shaders
copy-gngeo-shaders: $(GNGEO_INSTALL_PATH)/shaders/$(SHADER)
endif
endif
endif
endif



.PHONY: all clean
