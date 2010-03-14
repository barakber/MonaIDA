{-# LANGUAGE ForeignFunctionInterface #-}

module MonaIDA where
 
import Foreign.C
import Foreign.C.Types
import Foreign.C.String
import Control.Monad

-- imported functions --
foreign import stdcall unsafe "wrapped_get_screen_ea" c_get_screen_ea :: IO CInt
foreign import stdcall        "wrapped_jumpto"        c_jumpto :: CInt -> IO ()
foreign import stdcall        "wrapped_get_curline"   c_get_curline :: IO CString
foreign import stdcall        "wrapped_describe"      c_describe :: CInt -> CString -> IO ()
foreign import stdcall        "wrapped_msg"           c_msg :: CString -> IO CInt

-- exported functions --
foreign export ccall factorial_hs :: CInt -> CInt
factorial_hs = fromIntegral . product . flip take [1..]  . fromIntegral
 
foreign export ccall monaIDA :: CInt -> IO ()
monaIDA arg = do
	withCString "\n\nHello from Haskell\n" c_msg	
	
	c_get_curline >>= c_msg
	
	current_effective_address <- c_get_screen_ea
	current_line              <- c_get_curline
	c_describe current_effective_address current_line
	
	return () 

