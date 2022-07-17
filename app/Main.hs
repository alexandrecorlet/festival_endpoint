module Main where

import Control.Monad (unless)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Exit
import System.IO
import Text.ParserCombinators.ReadP (choice)

main :: IO ()
main = do
  setLocaleEncoding utf8
  menuBoasVindasPrompt

--menuPrincipalPrompt

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

  unless (choice == "7") $ do
    case choice of
      "1" -> menuComprarIngresso
      "2" -> listarAtracoesDoFestival
      "3" -> comandaMenu
      "4" -> consultarAtracao
      "5" -> consultarDiaDoFestival
      "6" -> consultarAtracoesPorData
      otherwise -> invalidOptionInput menuPrincipalPrompt

menuBoasVindas :: IO ()
menuBoasVindas = do
  putStrLn "\nSeja bem-vindo ao Festival Endpoint!"
  putStrLn "\nVocê já possui uma conta?\n"
  putStrLn "(1) Sim"
  putStrLn "(2) Não\n"

-- | Display menu
menuPrincipal :: IO ()
menuPrincipal = do
  putStrLn "\nMENU:\n"
  putStrLn "(1) Comprar ingresso"
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
  putStrLn "\nVocê é maior de idade?\n"
  putStrLn "(0) - Não"
  putStrLn "(1) - Sim\n"
  putStr "> "
  hFlush stdout
  maioridade <- getLine
  if checkValidCpf cpf && checkValidSenha senha
    then do
      writeDB cpf senha "users"
      writeDB cpf maioridade "maioridade"
      writeDB cpf "" "comanda"
      writeDB cpf "0" "valorComanda"
      putStrLn "\nConta Criada!\n"
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
  putStrLn "(4) Pizza de calabresa 300g - 20R$"
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
  putStrLn "(4) Pizza de calabresa 300g - 20R$"
  putStrLn "(5) Voltar ao menu principal\n"

menuComprarIngresso :: IO ()
menuComprarIngresso = do
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
  att <- hGetContents file
  let atracoes = "\n" ++ att ++ "\n"
  putStr atracoes
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
  att <- hGetContents file
  let atracaoInfo = "\n" ++ att
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
  ddf <- hGetContents file
  let diaDoFestivalInfo = "\n" ++ ddf
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
  if input == "1"
    then do
      let pathCpf = "app/database/currentUser.txt"
      fileCpf <- openFile pathCpf ReadMode
      cpf <- hGetContents fileCpf
      let pathMaioridade = "app/database/maioridade/" ++ cpf ++ ".txt"
      fileMaioridade <- openFile pathMaioridade ReadMode
      maioridade <- hGetContents fileMaioridade
      if maioridade == "1"
        then do menuItemsCompleto
        else do menuItemsIncompleto
      putStrLn "\nDigite o código do item desejado:\n"
      putStr "> "
      hFlush stdout
      idItem <- getLine
      if idItem == "5"
        then do menuPrincipalPrompt
        else do putStrLn "\nDigite a quantidade desejada:\n"
      putStr "> "
      hFlush stdout
      qnt <- getLine
      adicionarCompra idItem qnt
      menuPrincipalPrompt
    else do
      getComanda
      menuPrincipalPrompt

checkValidIngressoId :: String -> Bool
checkValidIngressoId id = id `elem` ["L1", "L2", "L3", "R1", "R2", "R3"]

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

getComanda :: IO ()
getComanda = do
  cpf <- readFile "app/database/currentUser.txt"
  let valorComandaPath = "app/database/valorComanda/" ++ cpf ++ ".txt"
  let comandaPath = "app/database/comanda/" ++ cpf ++ ".txt"
  valorComanda <- readFile valorComandaPath
  comanda <- readFile comandaPath

  putStrLn ("Valor total: " ++ valorComanda ++ "\n" ++ comanda)

adicionarCompra :: String -> String -> IO ()
adicionarCompra itemId qntd = do
  cpf <- readFile "app/database/currentUser.txt"
  let itemPath = "app/database/itens/" ++ itemId ++ ".txt"
  let comandaPath = "app/database/comanda/" ++ cpf ++ ".txt"
  let valorComandaPath = "app/database/valorComanda/" ++ cpf ++ ".txt"

  item <- readFile itemPath

  valorComandaFile <- openFile valorComandaPath ReadWriteMode
  valorComanda <- hGetContents valorComandaFile

  -- funcao que le ultima linha do arquivo -int
  let descricaoArray = map ((!!) (lines item)) [(length (lines item) -2)]
  let valorItemArray = map ((!!) (lines item)) [(length (lines item) -1)]
  let descricao = head descricaoArray

  let valorItem = head valorItemArray

  let qntdInt = read qntd :: Integer
  let valorComandaInt = read valorComanda :: Integer
  let valorItemInt = read valorItem :: Integer

  let newComanda = descricao ++ " - " ++ qntd ++ "\n"
  let newValorComanda = valorComandaInt + (qntdInt * valorItemInt)

  let newValorComandaString = show newValorComanda

  --seq fecha o arquivo aberto para poder sobesscrever em paz
  putStrLn ("Seu total agora é de " ++ newValorComandaString ++ "R$")
  valorComanda `seq` hClose valorComandaFile
  writeFile valorComandaPath newValorComandaString
  appendFile comandaPath newComanda

consultarAtracoesPorData :: IO ()
consultarAtracoesPorData = do
  putStrLn "\nDigite a data inicial no formato DD MM AAAA: (separado por espaço)"
  putStr "> "
  hFlush stdout
  ini <- getLine
  putStrLn "\nDigite a data final no formato DD MM AAAA: (separado por espaço)"
  putStr "> "
  hFlush stdout
  fim <- getLine

  let i = split ini ' '
  let f = split fim ' '

  let dataInicial = toDate i
  let dataFinal = toDate f

  let saida = queryAtracoesPorData atracoes dataInicial dataFinal

  putStrLn saida

  menuPrincipalPrompt

-- Funcões com Data ###############################################
type Data = (Int, Int, Int)
type AtracoesByDate = (String, Data)

l1 :: AtracoesByDate
l2 :: AtracoesByDate
l3 :: AtracoesByDate
r1 :: AtracoesByDate
r2 :: AtracoesByDate
r3 :: AtracoesByDate

l1 = ("Annita - Armas e Rosas - CPM22", (10, 12, 2022))
l2 = ("Donzela De Ferro - EDEN - Fresno", (11, 12, 2022))
l3 = ("Kanye Oeste - Lady Gaga - Lea Corlet", (12, 12, 2022))
r1 = ("Luiza Sonza - MO - Skrillex", (05, 09, 2023))
r2 = ("The Killers - Ze Cowman - Santana", (06, 09, 2023))
r3 = ("Lana - Aurora - MO", (07, 09, 2023))

atracoes :: [AtracoesByDate]
atracoes = [r3, r2, r1, l3, l2, l1]

getAtracoes :: AtracoesByDate -> String
getAtracoes (x, (_, _, _)) = "" ++ x

getData :: AtracoesByDate -> Data
getData (_, (d, m, a)) = (d, m, a)

getDia :: Data -> Int
getDia (d, _, _) = d

getMes :: Data -> Int
getMes (_, m, _) = m

getAno :: Data -> Int
getAno (_, _, a) = a

checkValidDate :: Data -> Bool
checkValidDate n | getDia n > 31 = False
                | getDia n < 1 = False
                | getMes n > 12 = False
                | getMes n < 1 = False
                | getAno n < 1 = False
                | otherwise = True

toDate :: [String] -> Data
toDate s = (read (head s), read (head (tail s)), read (last s))

checkValidInterval :: Data -> Data -> Bool
checkValidInterval x y | menorOuIgual x y = True
                      | otherwise = False

maiorOuIgual :: Data -> Data -> Bool
maiorOuIgual x y = (getDia x + (getMes x * 30) + (getAno x * 12 * 30)) >= (getDia y + (getMes y * 30) + (getAno y * 12 * 30)) 

menorOuIgual :: Data -> Data -> Bool
menorOuIgual x y = (getDia x + (getMes x * 30) + (getAno x * 12 * 30)) <= (getDia y + (getMes y * 30) + (getAno y * 12 * 30)) 

atracoesToString :: AtracoesByDate -> String
atracoesToString x = "\n" ++ show (getDia (getData x)) ++ "/" ++ show (getMes (getData x)) ++ "/" ++ show (getAno (getData x)) ++ " - "++ getAtracoes x 

consultaDatas :: AtracoesByDate -> Data -> Data -> String
consultaDatas x ini fim | maiorOuIgual (getData x) ini && menorOuIgual (getData x) fim  = atracoesToString x
                      | otherwise = ""

queryAtracoesPorData :: [AtracoesByDate] -> Data -> Data -> String
queryAtracoesPorData [] _ _ = ""
queryAtracoesPorData (x:xs) ini fim = queryAtracoesPorData xs ini fim ++ consultaDatas x ini fim

split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split cs delim

-- Funções com Data ###############################################
