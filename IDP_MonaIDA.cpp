/*
compile on MSYS:
$ ghc -c -optc-O MonaIDA.hs
$ ghc -optc-DWIN32 -optc-D__NT__ -optc-D__IDP__ -optc-w -optc-mrtd -optc-dll -shared -o MonaIDA.plw IDP_MonaIDA.cpp MonaIDA.o MonaIDA_stub.o ida_wrappers.cpp -I"/c/Program Files/IDA/sdk/include"/ ida.a
*/

#include <ida.hpp>
#include <name.hpp>
#include <idp.hpp>
#include <loader.hpp>

#include "MonaIDA_stub.h"

int IDP_MonaIDA_init(void)
{
	hs_init(0, NULL);
	return PLUGIN_KEEP;
}


void IDP_MonaIDA_term(void)
{
	hs_exit();
	return;
}


void IDP_MonaIDA_run(int arg)
{
	monaIDA(arg);
	return;
}


char IDP_MonaIDA_comment[] = "MonaIDA - Haskell IDA bindings";
char IDP_MonaIDA_help[]    = "MonaIDA";
char IDP_MonaIDA_name[]    = "MonaIDA";
char IDP_MonaIDA_hotkey[]  = "Ctrl-1";

plugin_t PLUGIN = {
	IDP_INTERFACE_VERSION,
	0, // flags
	(int (idaapi *)(void))&IDP_MonaIDA_init,
	(void (idaapi *)(void))&IDP_MonaIDA_term,
	(void (idaapi *)(int arg))&IDP_MonaIDA_run,
	IDP_MonaIDA_comment,
	IDP_MonaIDA_help,
	IDP_MonaIDA_name,
	IDP_MonaIDA_hotkey
};
