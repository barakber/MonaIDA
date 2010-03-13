/*
compile on MSYS:
$ ghc -c -optc-O MonaIDA.hs
$ ghc -optc-DWIN32 -optc-D__NT__ -optc-D__IDP__ -optc-w -optc-mrtd -optc-dll -shared -o MonaIDA.plw IDP_MonaIDA.cpp MonaIDA.o MonaIDA_stub.o ida_wrappers.cpp -I"/c/Program Files/IDA/sdk/include"/ ida.a
*/

#include <ida.hpp>
#include <idp.hpp>
#include <loader.hpp>

#include "MonaIDA_stub.h"


int IDP_MonaIDA_init(void)
{
	// Do checks here to ensure your plug-in is being used within
	// an environment it was written for. Return PLUGIN_SKIP if the
	// checks fail, otherwise return PLUGIN_KEEP.
	hs_init(0, NULL);
	return PLUGIN_KEEP;
}



void IDP_MonaIDA_term(void)
{
	// Stuff to do when exiting, generally you'd put any sort
	// of clean-up jobs here.
	hs_exit();
	return;
}



// The plugin can be passed an integer argument from the plugins.cfg
// file. This can be useful when you want the one plug-in to do
// something different depending on the hot-key pressed or menu
// item selected.
void IDP_MonaIDA_run(int arg)
{
	// The "meat" of your plug-in
	msg("\n\n---(Calling Haskell)---\n Factorial 5 from haskell: %d\n", factorial_hs(5));
	msg("---(Calling Haskell that calls IDAAPI)---\n");
	monaIDA();
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
