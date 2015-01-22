-- Impure code copied from www.catonmat.net/blog/simple-haskell-tcp-server

import Network (listenOn, withSocketsDo, accept, PortID(..), Socket)
import System.Environment (getArgs)
import System.IO (hSetBuffering, hGetLine, hPutStrLn, BufferMode(..), Handle)
import Control.Concurrent (forkIO)

respond :: String -> String
respond request = request

requestProcessor :: Handle -> IO ()
requestProcessor handle = do
    line <- hGetLine handle
    hPutStrLn handle $ respond line
    requestProcessor handle

sockHandler :: Socket -> IO ()
sockHandler sock = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    forkIO $ requestProcessor handle
    sockHandler sock

main :: IO ()
main = withSocketsDo $ do
    args <- getArgs
    let port = fromIntegral (read $ head args :: Int)
    sock <- listenOn $ PortNumber port
    putStrLn $ "Listening on " ++ (head args)
    sockHandler sock
