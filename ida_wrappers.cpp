#include <kernwin.hpp>
#include <lines.hpp>
#include <stdlib.h>

/* wrapping because these shits are inline.. */
#ifdef __cplusplus
extern "C" {
#endif



ea_t wrapped_get_screen_ea(void)
{
	return get_screen_ea();
}

void describe(ea_t effective_address, const char *string) {
  describe(effective_address, 1, "%s", string);
}

#ifdef __cplusplus
}
#endif
