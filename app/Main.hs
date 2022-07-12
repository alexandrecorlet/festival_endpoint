module Main where

import Control.Monad (unless)
import System.Exit
import System.IO
  ( IO,
    IOMode (ReadMode, WriteMode),
    hFlush,
    openFile,
    stdout,
  )
import Text.ParserCombinators.ReadP (choice)

main :: IO ()
main = do
  menuBoasVindasPrompt

---                   Login               ->
--- menuBoasVindas ->
---                   Criar Conta

---menuPrincipalPrompt

menuBoasVindasPrompt :: IO ()
menuBoasVindasPrompt = do
  menuBoasVindas
  putStr "> "
  hFlush stdout
  choice <- getLine
  do
    case choice of
      "1" -> putStrLn "LOGIN"
      "2" -> menuCriarConta
      otherwise -> invalidOption menuBoasVindas

menuPrincipalPrompt :: IO ()
menuPrincipalPrompt = do
  menuPrincipalPrompt
  putStr "> "
  hFlush stdout
  choice <- getLine

  unless (choice == "9") $ do
    case choice of
      "1" -> putStrLn "TODO"
      "2" -> putStrLn "TODO"
      "3" -> putStrLn "TODO"
      "4" -> putStrLn "TODO"
      "5" -> putStrLn "TODO"
      "6" -> putStrLn "TODO"
      "7" -> putStrLn "TODO"
      "8" -> putStrLn "TODO"
      otherwise -> invalidOption menuPrincipalPrompt

menuBoasVindas :: IO ()
menuBoasVindas = do
  putStrLn "\n Seja bem-vindo ao Festival Endpoint!"
  putStrLn "\n Você já possui uma conta?\n"
  putStrLn "(1) Sim"
  putStrLn "(2) Não\n"

-- | Display menu
menuPrincipal :: IO ()
menuPrincipal = do
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

--- CRIAR CONTA -> CPF -> VALIDO -> SENHA -> VALIDA -> salvar em um TXT
--- CRIAR CONTA -> CPF -> VALIDO -> SENHA -> VALIDA -> VALIDAR SE ESTÁ NO TXT

menuCriarConta :: IO ()
menuCriarConta = do
  getCpf

getCpf :: IO ()
getCpf = do
  putStr "\n Digite seu CPF (apenas números)"
  putStr "> "
  hFlush stdout
  cpf <- getLine
  if checkValidCpf cpf
    then getSenha
    else invalidOption getCpf

getSenha :: IO ()
getSenha = do
  putStr "\n Digite sua senha (no mínimo 6 dígitos)"
  putStr "> "
  hFlush stdout
  senha <- getLine
  if checkValidSenha senha
    then print "salva no txt"
    else invalidOption getSenha

checkValidCpf :: String -> Bool
checkValidCpf cpf = checkValidCpfSize cpf && checkIfElementsAreNumbers cpf

checkValidCpfSize :: String -> Bool
checkValidCpfSize cpf
  | let size = length cpf, size == 11 = True
  | otherwise = False

checkIfElementsAreNumbers :: String -> Bool
checkIfElementsAreNumbers "" = True
checkIfElementsAreNumbers (x : xs)
  | x `elem` ['0' .. '9'] = checkIfElementsAreNumbers xs
  | otherwise = False

checkValidSenha :: String -> Bool
checkValidSenha senha
  | let size = length senha, size > 5 = True
  | otherwise = False

-- | Prompt user
invalidOption :: IO () -> IO ()
invalidOption f = do
  putStrLn "\nOPCAO INVALIDA!"
  f

-- | Prompt user
invalidOptionInput :: IO () -> IO ()
invalidOptionInput f = do
  putStrLn "\nInput incorreto!"
  f