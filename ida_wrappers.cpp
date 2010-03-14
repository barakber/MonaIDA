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

bool wrapped_jumpto(ea_t ea)
{
	return jumpto(ea, -1);
}

char *wrapped_get_curline(void)
{
	char *current_line = get_curline();
	tag_remove(current_line, current_line, 0);
	return current_line;
}

int wrapped_msg(const char *string)
{
	return msg("%s", string);
}

void wrapped_describe(ea_t effective_address, const char *string) {
  describe(effective_address, 1, "%s", string);
}

#ifdef __cplusplus
}
#endif
