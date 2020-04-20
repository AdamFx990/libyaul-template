#include <yaul.h>

#include <stdio.h>
#include <stdlib.h>

static void _hardware_init(void);

int main(void) {
  _hardware_init();
  dbgio_dev_default_init(DBGIO_DEV_VDP2_ASYNC);

  while (true) {
    dbgio_buffer("Hello, World!\n");

    dbgio_flush();
    vdp_sync(0);
    dbgio_init();
  }

  return 0;
}

static void _hardware_init(void) {
  vdp2_tvmd_display_res_set(VDP2_TVMD_INTERLACE_NONE, VDP2_TVMD_HORZ_NORMAL_A,
                            VDP2_TVMD_VERT_224);

  vdp2_scrn_back_screen_color_set(VDP2_VRAM_ADDR(3, 0x01FFFE),
                                  COLOR_RGB555(0, 3, 15));

  cpu_intc_mask_set(0);

  vdp2_tvmd_display_set();
}
