#include <kernwin.hpp>
#include <lines.hpp>
#include <funcs.hpp>
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

void wrapped_describe(ea_t effective_address, const char *string) 
{
	describe(effective_address, 1, "%s", string);
}

char function_comment_buffer[1024] = {0};
char *wrapped_get_func_cmt(func_t *fn, bool repeatable)
{
	int length = -1;
	char *original_result = get_func_cmt(fn, repeatable);
	if (NULL == original_result) { return ""; }
	length = strlen(original_result);
	qstrncpy(function_comment_buffer, original_result, length+1);
	qfree(original_result);
	return function_comment_buffer;
}

bool wrapped_set_func_cmt(func_t *fn, const char *cmt, bool repeatable)
{
	return set_func_cmt(fn, cmt, repeatable);
}

void wrapped_del_func_cmt(func_t *fn, bool repeatable)
{
	del_func_cmt(fn, repeatable);
}

char function_name_buffer[1024] = {0};
char *wrapped_get_func_name(ea_t ea)
{
	size_t bufsize = 0;
	char *function_name = get_func_name(ea, function_name_buffer, sizeof(function_name_buffer)-1);
	if (NULL == function_name) { return ""; }
	return function_name_buffer;
}

#ifdef __cplusplus
}
#endif
