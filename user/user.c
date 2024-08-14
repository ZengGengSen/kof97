typedef void (*UserRequestFunc)();

static void init_system() {
  // clear_user_work_ram();
  // init_sound();

  switch_bank(2);

  BIOS_PLAYER_MOD1 = 0;

  player_start_flag[0] = 0;
  player_start_flag[1] = 0;

  key_remap_flag = 0;
  screen_flag = 0;
  backup_data = 0;

  is_player_exit_copy = 0;

  palette_ptr->entrys[0].index = -1;

  unknown_flag_a816[0] = 4;
  unknown_flag_a816[1] = 4;

  unknown_flag_ec33 = 0xff;

  clear_title_fix_layer();
}

static void init();
static void boot_animation();
static void demo();
static void title();
static const UserRequestFunc user_request_table[4] = {
  init,
  boot_animation,
  demo,
  title
};

void user() {
  BIOS_SYSTEM_MODE &= ~0x80;
  user_request_table[BIOS_USER_REQUEST]();
}

#include "demo.c"

static void init() {
  // do something
}

static void boot_animation() {
  // do something
}

static void title() {
  // do something

}
