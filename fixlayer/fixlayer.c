void clear_title_fix_layer() {
  volatile u32 *ptr = (volatile u32*)title_fix_layer;
  *ptr++ = 0;
  *ptr++ = 0;
  *ptr++ = 0;
  *ptr   = 0;
}
