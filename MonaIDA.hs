{-# LANGUAGE ForeignFunctionInterface #-}

-- exported functions -- 
module MonaIDA where
 
import Foreign.C
import Foreign.C.Types
import Foreign.C.String
import Control.Monad
import Control.Concurrent

-- imported functions --
foreign import stdcall unsafe "wrapped_get_screen_ea" c_get_screen_ea :: IO CInt
foreign import stdcall "describe" c_describe :: CInt -> CString -> IO ()

-- exported functions --
foreign export ccall factorial_hs :: CInt -> CInt
factorial_hs = fromIntegral . product . flip take [1..]  . fromIntegral
 
foreign export ccall monaIDA :: IO ()
monaIDA = do
	current_effective_address <- c_get_screen_ea
	withCString " ^---- Haskell says hi!!  ----^" (c_describe current_effective_address)
	return () 

