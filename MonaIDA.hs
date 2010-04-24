{-# LANGUAGE ForeignFunctionInterface #-}
-- not thread-safe

module MonaIDA where
 
import Foreign.C
import Foreign.C.Types
import Foreign.C.String
import Foreign.Marshal.Alloc (free)
import Control.Monad

type EA = Int
type Function = Int
type CBool = CInt
type StringInfo = CInt
type CRefType = CInt
type DRefType = CInt

---------------------- <kernwin.hpp> --------------------------------------------------------
foreign import stdcall unsafe "wrapped_get_screen_ea" c_get_screen_ea :: IO CInt
foreign import stdcall unsafe "wrapped_jumpto"        c_jumpto :: CInt -> IO ()
foreign import stdcall unsafe "wrapped_get_curline"   c_get_curline :: IO CString
foreign import stdcall unsafe "wrapped_describe"      c_describe :: CInt -> CString -> IO ()
foreign import stdcall unsafe "wrapped_msg"           c_msg :: CString -> IO CInt

get_screen_ea :: IO EA
get_screen_ea = fmap fromIntegral c_get_screen_ea

jumpto :: EA -> IO ()
jumpto = c_jumpto . fromIntegral

get_curline :: IO String
get_curline = c_get_curline >>= peekCAString

describe :: EA -> String -> IO ()
describe ea message = withCString message (c_describe $ fromIntegral ea)

msg :: String -> IO Int
msg message = fmap fromIntegral $ withCString message c_msg
--------------------------------------------------------------------------------------------

--------------------- <funcs.hpp> ----------------------------------------------------------
foreign import stdcall unsafe "get_func"              c_get_func :: CInt -> IO CInt
foreign import stdcall unsafe "getn_func"             c_getn_func :: CInt -> IO CInt
foreign import stdcall unsafe "get_func_qty"          c_get_func_qty :: IO CInt
foreign import stdcall unsafe "get_func_num"          c_get_func_num :: CInt -> IO CInt
foreign import stdcall unsafe "get_prev_func"         c_get_prev_func :: CInt -> IO CInt
foreign import stdcall unsafe "get_next_func"         c_get_next_func :: CInt -> IO CInt
foreign import stdcall unsafe "wrapped_get_func_cmt"  c_get_func_cmt :: CInt -> CBool -> IO CString
foreign import stdcall unsafe "wrapped_set_func_cmt"  c_set_func_cmt :: CInt -> CString -> CBool -> IO CBool
foreign import stdcall unsafe "wrapped_del_func_cmt"  c_del_func_cmt :: CInt -> CBool -> IO ()
foreign import stdcall unsafe "add_func"              c_add_func :: CInt -> CInt -> IO CBool
foreign import stdcall unsafe "del_func"              c_del_func :: CInt -> IO CBool
foreign import stdcall unsafe "func_setstart"         c_func_setstart :: CInt -> CInt -> IO CBool
foreign import stdcall unsafe "func_setend"           c_func_setend :: CInt -> CInt -> IO CBool
foreign import stdcall unsafe "reanalyze_function"    c_reanalyze_function :: CInt -> CInt -> CInt -> CBool -> IO ()
foreign import stdcall unsafe "wrapped_get_func_name" c_get_func_name :: CInt -> IO CString
foreign import stdcall unsafe "get_prev_func_addr"    c_get_prev_func_addr :: CInt -> CInt -> IO CInt
foreign import stdcall unsafe "get_next_func_addr"    c_get_next_func_addr :: CInt -> CInt -> IO CInt

get_func :: EA -> IO Function
get_func ea = fmap fromIntegral $ c_get_func . fromIntegral $ ea

getn_func :: Int -> IO Function
getn_func idx = fmap fromIntegral $ c_getn_func . fromIntegral $ idx

get_func_qty :: IO Int
get_func_qty = fmap fromIntegral c_get_func_qty

get_func_num :: EA -> IO Int
get_func_num ea = fmap fromIntegral $ c_get_func_num . fromIntegral $ ea

get_prev_func :: EA -> IO Function
get_prev_func ea = fmap fromIntegral $ c_get_prev_func . fromIntegral $ ea

get_next_func :: EA -> IO Function
get_next_func ea = fmap fromIntegral $ c_get_next_func . fromIntegral $ ea

get_func_cmt :: Function -> Int -> IO String
get_func_cmt ea is_repeatable = c_get_func_cmt (fromIntegral ea) (fromIntegral is_repeatable) >>= peekCAString

set_func_cmt :: Function -> String -> Int -> IO Int
set_func_cmt function comment is_repeatable = do
	c_comment <- newCAString comment
	result <- fmap fromIntegral $ c_set_func_cmt (fromIntegral function) c_comment (fromIntegral is_repeatable)
	free c_comment
	return result

del_func_cmt :: Function -> Int -> IO ()
del_func_cmt function is_repeatable = c_del_func_cmt (fromIntegral function) (fromIntegral is_repeatable)

add_func :: EA -> EA -> IO Int
add_func start_ea end_ea = fmap fromIntegral $ c_add_func (fromIntegral start_ea) (fromIntegral end_ea)

del_func :: EA -> IO Int
del_func ea = fmap fromIntegral $ c_del_func . fromIntegral $ ea

func_setstart :: EA -> EA -> IO Int
func_setstart ea1 ea2 = fmap fromIntegral $ c_func_setstart (fromIntegral ea1) (fromIntegral ea2)

func_setend :: EA -> EA -> IO Int
func_setend ea1 ea2 = fmap fromIntegral $ c_func_setend (fromIntegral ea1) (fromIntegral ea2)

reanalyze_function :: Function -> EA -> EA -> Int -> IO ()
reanalyze_function function start_ea end_ea bool = c_reanalyze_function (fromIntegral function) (fromIntegral start_ea) (fromIntegral end_ea) (fromIntegral bool)

get_func_name :: EA -> IO String
get_func_name ea = c_get_func_name (fromIntegral ea) >>= peekCAString

get_prev_func_addr :: Function -> EA -> IO EA
get_prev_func_addr function ea = fmap fromIntegral (c_get_prev_func_addr (fromIntegral function) (fromIntegral ea))

get_next_func_addr :: Function -> EA -> IO EA
get_next_func_addr function ea = fmap fromIntegral (c_get_next_func_addr (fromIntegral function) (fromIntegral ea))
--------------------------------------------------------------------------------------------

--------------------- <strlist.hpp> ----------------------------------------------------------
foreign import stdcall unsafe "refresh_strlist" c_refresh_strlist :: CInt -> CInt -> IO ()
foreign import stdcall unsafe "get_strlist_qty" c_get_strlist_qty :: IO CInt

refresh_strlist :: EA -> EA -> IO ()
refresh_strlist start_ea end_ea = c_refresh_strlist (fromIntegral start_ea) (fromIntegral end_ea)

get_strlist_qty :: IO Int
get_strlist_qty = fmap fromIntegral c_get_strlist_qty

--foreign import stdcall unsafe "get_strlist_item"      c_get_strlist_item :: CInt -> StringInfo -> IO CBool
--get_strlist_item :: Int -> 
--------------------------------------------------------------------------------------------

--------------------- <xref.hpp> ----------------------------------------------------------
foreign import stdcall unsafe "add_cref"              c_add_cref :: EA -> EA -> CRefType -> IO ()

foreign import stdcall unsafe "del_cref"              c_del_cref :: EA -> EA -> CInt -> IO CInt
foreign import stdcall unsafe "add_dref"              c_add_dref :: EA -> EA -> DRefType -> IO ()
foreign import stdcall unsafe "del_dref"              c_del_dref :: EA -> EA -> IO ()
foreign import stdcall unsafe "get_first_dref_from"   c_get_first_dref_from :: EA -> IO EA
foreign import stdcall unsafe "get_next_dref_from"    c_get_next_dref_from :: EA -> EA -> IO EA
foreign import stdcall unsafe "get_first_dref_to"     c_get_first_dref_to :: EA -> IO EA
foreign import stdcall unsafe "get_next_dref_to"      c_get_next_dref_to :: EA -> EA -> IO EA
foreign import stdcall unsafe "get_first_cref_from"   c_get_first_cref_from :: EA -> IO EA
foreign import stdcall unsafe "get_next_cref_from"    c_get_next_cref_from :: EA -> EA -> IO EA
foreign import stdcall unsafe "get_first_cref_to"     c_get_first_cref_to :: EA -> IO EA
foreign import stdcall unsafe "get_next_cref_to"      c_get_next_cref_to :: EA -> EA -> IO EA
--------------------------------------------------------------------------------------------

--------------------- <names.hpp> ----------------------------------------------------------
foreign import stdcall unsafe "set_name"         c_set_name :: CInt -> CString -> CInt -> IO CBool
foreign import stdcall unsafe "get_name_ea"      c_get_name_ea :: CInt -> CString -> IO CInt
foreign import stdcall unsafe "get_name_base_ea" c_get_name_base_ea :: CInt -> CInt -> IO CInt
foreign import stdcall unsafe "get_nlist_size"   c_get_nlist_size :: IO CInt
foreign import stdcall unsafe "get_nlist_idx"    c_get_nlist_idx :: CInt -> IO CInt
foreign import stdcall unsafe "is_in_nlist"      c_is_in_nlist :: CInt -> IO CBool
foreign import stdcall unsafe "get_nlist_ea"     c_get_nlist_ea :: CInt -> IO CInt
foreign import stdcall unsafe "get_nlist_name"   c_get_nlist_name :: CInt -> IO CString
foreign import stdcall unsafe "rebuild_nlist"    c_rebuild_nlist :: IO ()

set_name :: EA -> String -> Int -> IO Int
set_name ea name flag = do
	c_name <- newCAString name
	result <- fmap fromIntegral $ c_set_name (fromIntegral ea) c_name (fromIntegral flag)
	free c_name
	return result
	
get_name_ea :: EA -> String -> IO EA
get_name_ea from_ea name = do
	c_name <- newCAString name
	result <- fmap fromIntegral $ c_get_name_ea (fromIntegral from_ea) c_name
	free c_name
	return result

get_name_base_ea :: EA -> EA -> IO EA
get_name_base_ea from_ea to_ea = fmap fromIntegral $ c_get_name_base_ea (fromIntegral from_ea) (fromIntegral to_ea)

get_nlist_size :: IO Int
get_nlist_size = fmap fromIntegral c_get_nlist_size

get_nlist_idx :: EA -> IO Int
get_nlist_idx ea = fmap fromIntegral $ c_get_nlist_idx (fromIntegral ea)

is_in_nlist :: EA -> IO Int
is_in_nlist ea = fmap fromIntegral $ is_in_nlist (fromIntegral ea)

get_nlist_ea :: Int -> IO EA
get_nlist_ea idx = fmap fromIntegral $ c_get_nlist_ea (fromIntegral idx)

get_nlist_name :: Int -> IO String
get_nlist_name idx = c_get_nlist_name (fromIntegral idx) >>= peekCAString

rebuild_nlist :: IO ()
rebuild_nlist = c_rebuild_nlist
--------------------------------------------------------------------------------------------

getNames :: IO [String]
getNames = do
	number_of_names <- get_nlist_size
	forM [0 .. number_of_names - 1] get_nlist_name >>= return
	
getFunctions :: IO [Function]
getFunctions = do
	number_of_functions <- get_func_qty
	forM [0 .. number_of_functions -1] getn_func >>= return
	
getCurrentFunction :: IO Function
getCurrentFunction = get_screen_ea >>= get_func


foreign export ccall monaIDA :: CInt -> IO ()
monaIDA arg = do
	msg "\n\nHello from Haskell\n"
	
	-- print all names in message window 
	getNames >>= flip forM (msg . (++ "  ---   "))
	msg "\n"
	
	-- add a comment for each function
	functions <- getFunctions
	forM functions $ \function -> do 
		set_func_cmt function "---~~~ Haskell generated comment ~~~---" 1

	-- print current function's comment
	current_function <- getCurrentFunction
	set_func_cmt current_function "comment maister supreme" 1
	get_func_cmt current_function 1 >>= msg
	msg "\n\n"
	
	return () 

