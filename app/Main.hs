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
  menuPrincipal
  putStr "> "
  hFlush stdout
  choice <- getLine

  unless (choice == "8") $ do
    case choice of
      "1" -> menuComprarIngresso
      "2" -> listarAtracoesDoFestival
      "3" -> comandaMenu
      "4" -> consultarAtracao
      "5" -> consultarDiaDoFestival
      "6" -> putStrLn "TODO"
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
  putStrLn "(1) Compra ingresso"
  putStrLn "(2) Listar dias do festival"
  putStrLn "(3) Consultar comanda online"
  putStrLn "(4) Consultar atracao"
  putStrLn "(5) Consultar dia do festival"
  putStrLn "(6) Consultar atracoes por data"
  putStrLn "(7) Sair\n"

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
      menuPrincipalPrompt
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
          menuPrincipalPrompt
        else do
          putStrLn "ERRO AO FAZER LOGIN"
          menuLogin
    else invalidOptionInput menuCriarConta

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

menuItemsIncompleto :: IO ()
menuItemsIncompleto = do
  putStrLn "\nItens:\n"
  putStrLn "(0) Coxinha de Frango 300g - 20R$"
  putStrLn "(1) Água 300ml - 11R$"
  putStrLn "(2) Refrigerante 300ml - 11R$"
  putStrLn "(3) Boné do festival - 100R$"
  putStrLn "(4) Pizza de calabresa 300g - 20R$\n"
  putStrLn "(5) Voltar ao menu principal\n"

menuListarDiasDeUmFestival :: IO ()
menuListarDiasDeUmFestival = do
  putStrLn "\nItens:\n"
  putStrLn "(0) Coxinha de Frango 300g - 20R$"
  putStrLn "(1) Água 300ml - 11R$"
  putStrLn "(2) Refrigerante 300ml - 11R$"
  putStrLn "(3) Boné do festival - 100R$"
  putStrLn "(4) Pizza de calabresa 300g - 20R$\n"
  putStrLn "(5) Voltar ao menu principal\n"

menuComprarIngresso :: IO ()
menuComprarIngresso = do
  putStrLn "\nVocê é maior de idade?\n"
  putStrLn "(0) - Não"
  putStrLn "(1) - Sim\n"
  putStr "> "
  hFlush stdout
  maioridade <- getLine
  putStrLn "\nQual o id do dia do festival?\n"
  putStr "> "
  hFlush stdout
  idDiaDoFestival <- getLine
  if checkValidIngressoId idDiaDoFestival
    then do
      let cpfPath = "app/database/currentUser.txt"
      file <- openFile cpfPath ReadMode
      cpf <- hGetContents file
      let path = "app/database/ingressos/" ++ cpf ++ ".txt"
      --- Salvar ingresso
      writeFile path idDiaDoFestival
      print "Ingresso comprado com sucessso!"
      menuPrincipalPrompt
    else do
      invalidId menuPrincipalPrompt --- salva ingresso do cachorro

listarAtracoesDoFestival :: IO ()
listarAtracoesDoFestival = do
  let atracoesPath = "app/database/diasDeFestival/atracoesFestival.txt"
  file <- openFile atracoesPath ReadMode
  atracoes <- hGetContents file
  putStrLn atracoes
  menuPrincipalPrompt

consultarAtracao :: IO ()
consultarAtracao = do
  putStrLn "\nDigite o nome da atração:\n"
  putStr "> "
  hFlush stdout
  atracao <- getLine
  let formatedAtracao = addUnderscore atracao
  let path = "app/database/atracoes/" ++ formatedAtracao ++ ".txt"
  file <- openFile path ReadMode
  atracaoInfo <- hGetContents file
  putStrLn atracaoInfo
  menuPrincipalPrompt

consultarDiaDoFestival :: IO ()
consultarDiaDoFestival = do
  putStrLn "\nDigite o código do dia do festival"
  putStrLn "\n(Utilize a inicial do Festival e o número referente ao dia do festival)"
  putStrLn "\n(Exemplo: L1 para LollaPalluisa - Dia 1)\n"
  putStr "> "
  hFlush stdout
  diaDoFestival <- getLine
  let path = "app/database/diasDeFestival/" ++ diaDoFestival ++ ".txt"
  file <- openFile path ReadMode
  diaDoFestivalInfo <- hGetContents file
  putStrLn diaDoFestivalInfo
  menuPrincipalPrompt

comandaMenu :: IO ()
comandaMenu = do
  putStrLn "\n Escolha uma opção:\n"
  putStrLn "(1) - Comprar Items"
  putStrLn "(2) - Extrato\n"
  putStr "> "
  hFlush stdout
  input <- getLine
  if (input == "1")
    then do (print "função de compra")
    else do (print "função de listar items")

checkValidIngressoId :: String -> Bool
checkValidIngressoId id = id `elem` ["1", "2", "3", "4", "5", "6"]

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

invalidId :: IO () -> IO ()
invalidId f = do
  putStrLn "\nID incorreto!"
  f

writeDB :: String -> String -> String -> IO ()
writeDB cpf senha path = do
  let finalPath = "app/database/" ++ path ++ "/" ++ cpf ++ ".txt"
  writeFile finalPath senha

saveCurrentUser :: String -> IO ()
saveCurrentUser cpf = do
  let finalPath = "app/database/currentUser.txt"
  writeFile finalPath cpf

removeCarriageReturn :: String -> String
removeCarriageReturn str = [ch | ch <- str, ch /= '\n']

addUnderscore :: String -> String
addUnderscore "" = ""
addUnderscore (x : xs)
  | x == ' ' = '_' : addUnderscore xs
  | otherwise = x : addUnderscore xs