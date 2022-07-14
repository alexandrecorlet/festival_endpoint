module Main where

import Control.Monad (unless)
import System.Exit
import System.IO
import Text.ParserCombinators.ReadP (choice)

main :: IO ()
main = do
  menuBoasVindasPrompt

---menuPrincipalPrompt

menuBoasVindasPrompt :: IO ()
menuBoasVindasPrompt = do
  menuBoasVindas
  putStr "> "
  hFlush stdout
  choice <- getLine
  do
    case choice of
      "1" -> menuLogin
      "2" -> menuCriarConta
      otherwise -> invalidOptionInput menuBoasVindas

menuPrincipalPrompt :: IO ()
menuPrincipalPrompt = do
  menuPrincipalPrompt
  putStr "> "
  hFlush stdout
  choice <- getLine

  unless (choice == "8") $ do
    case choice of
      "1" -> putStrLn "TODO"
      "2" -> putStrLn "TODO"
      "3" -> putStrLn "TODO"
      "4" -> putStrLn "TODO"
      "5" -> putStrLn "TODO"
      "6" -> putStrLn "TODO"
      "7" -> putStrLn "TODO"
      otherwise -> invalidOptionInput menuPrincipalPrompt

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
  putStrLn "(2) Compra ingresso"
  putStrLn "(3) Listar dias do festival"
  putStrLn "(4) Consultar comanda online"
  putStrLn "(5) Consultar atracao"
  putStrLn "(6) Consultar dia do festival"
  putStrLn "(7) Consultar atracoes por data"
  putStrLn "(8) Sair\n"

--- CRIAR CONTA -> CPF -> VALIDO -> SENHA -> VALIDA -> salvar em um TXT
--- LOGAR CONTA  -> CPF -> VALIDO -> SENHA -> VALIDA -> VALIDAR SE ESTÁ NO TXT

menuCriarConta :: IO ()
menuCriarConta = do
  putStr "\n Digite seu CPF (apenas números)\n"
  putStr "\n> "
  hFlush stdout
  cpf <- getLine
  putStr "\n Digite sua senha (no mínimo 6 dígitos)\n"
  putStr "\n> "
  hFlush stdout
  senha <- getLine
  if checkValidCpf cpf && checkValidSenha senha
    then do
      writeDB cpf senha "users"
      putStrLn "Conta Criada!\n"
      saveCurrentUser cpf
      menuPrincipal
    else invalidOptionInput menuCriarConta

menuLogin :: IO ()
menuLogin = do
  putStr "\n Digite seu CPF (apenas números)"
  putStr "> "
  hFlush stdout
  cpf <- getLine
  putStr "\n Digite sua senha (no mínimo 6 dígitos)"
  putStr "> "
  hFlush stdout
  senha <- getLine
  if checkValidCpf cpf && checkValidSenha senha
    then do
      let finalPath = "app/database/" ++ "users" ++ "/" ++ cpf ++ ".txt"
      file <- openFile finalPath ReadMode
      senhaCadastro <- hGetContents file
      if senha == senhaCadastro
        then do 
          saveCurrentUser cpf
          menuPrincipal
        else do
          putStrLn "ERRO AO FAZER LOGIN"
          menuLogin
    else invalidOptionInput menuCriarConta

    -- | Display Itens com itens +18
menuItemsCompleto :: IO ()
menuItemsCompleto = do
  putStrLn "\nItens:\n"
  putStrLn "(0) Coxinha de Frango 300g - 20R$"
  putStrLn "(1) Água 300ml - 11R$"
  putStrLn "(2) Refrigerante 300ml - 11R$"
  putStrLn "(3) Boné do festival - 100R$"
  putStrLn "(4) Pizza de calabresa 300g - 20R$\n"
  putStrLn "(5) Cerveja 300ml - 10R$"
  putStrLn "(6) Cachaça 100ml - 35R$"
  putStrLn "(7) Pitu 100ml - 70R$"
  putStrLn "(8) Pinga 95ml - 80R$"
  putStrLn "(9) Voltar ao menu principal\n"

      -- | Display Itens Não alcóolicos
menuItemsIncompleto :: IO ()
menuItemsIncompleto = do
  putStrLn "\nItens:\n"
  putStrLn "(0) Coxinha de Frango 300g - 20R$"
  putStrLn "(1) Água 300ml - 11R$"
  putStrLn "(2) Refrigerante 300ml - 11R$"
  putStrLn "(3) Boné do festival - 100R$"
  putStrLn "(4) Pizza de calabresa 300g - 20R$\n"
  putStrLn "(5) Voltar ao menu principal\n"

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
invalidOption :: String -> IO () -> IO ()
invalidOption msg f = do
  putStrLn "\nOPCAO INVALIDA!"
  f

-- | Prompt user
invalidOptionInput :: IO () -> IO ()
invalidOptionInput f = do
  putStrLn "\nInput incorreto!"
  f

writeDB :: String -> String -> String -> IO ()
writeDB cpf senha path = do
  let finalPath = "app/database/" ++ path ++ "/" ++ cpf ++ ".txt"
  writeFile finalPath senha

saveCurrentUser :: String -> IO ()
saveCurrentUser cpf = do
  let finalPath = "app/database/currentUser.txt"
  writeFile cpf

