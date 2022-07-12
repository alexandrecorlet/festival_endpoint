module Main where

import System.IO
import System.Exit

import Control.Monad (unless)

-- | Display menu
menu :: IO()
menu = do
    putStrLn "\nMENU:\n"
    putStrLn "(1) Criar conta"
    putStrLn "(2) Fazer login"
    putStrLn "(3) Compra ingresso"
    putStrLn "(4) Listar dias do festival"
    putStrLn "(5) Consultar comanda online"
    putStrLn "(6) Consultar atracao"
    putStrLn "(7) Consultar dia do festival"
    putStrLn "(8) Consultar atracoes por data"
    putStrLn "(9) Sair\n"

-- | Prompt user
prompt :: IO()
prompt = do
    menu
    
    putStr "> " 
    hFlush stdout
    choice <- getLine

    unless (choice == "9") $ do
    
        {--
        case choice of 
            "1" -> putStrLn "TODO"
            "2" -> putStrLn "TODO"
            "3" -> putStrLn "TODO"
            "4" -> putStrLn "TODO"
            "5" -> putStrLn "TODO"
            "6" -> putStrLn "TODO"
            "7" -> putStrLn "TODO"
            "8" -> putStrLn "TODO"
        --}
        
        prompt

main :: IO ()
main = do
    putStrLn "Festival Endpoint\n" 
    
    prompt

