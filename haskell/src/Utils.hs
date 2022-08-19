module Utils where

import GHC.IO.Encoding (setLocaleEncoding)
import Data.Char
import System.IO
import System.Exit
import Text.ParserCombinators.ReadP (choice)

{-- |
    Valida o ingresso de um usuario.
    Retorna True caso o ingresso seja valido, False caso contrario.
--}
checkValidIngressoId :: String -> Bool
checkValidIngressoId id = id `elem` ["L1", "L2", "L3", "R1", "R2", "R3"]

{-- |
    Valida o CPF de um usuario. Um CPF eh valido sse
    todos os caracteres que o compoem sao digitos e
    possui um tamanho == 11. Retorna True caso o CPF 
    seja valido, False caso contrario.
--}
checkValidCpf :: String -> Bool
checkValidCpf cpf = checkValidCpfSize cpf && checkIfElementsAreNumbers cpf

{-- |
    Valida o tamanho do CPF. Um CPF possui
    tamanho valido se len(CPF) == 11, caso
    contrario o CPF eh invalido.
--}
checkValidCpfSize :: String -> Bool
checkValidCpfSize cpf = length cpf == 11

-- | Verifica se todos os caracteres do CPF sao digitos.
checkIfElementsAreNumbers :: String -> Bool
checkIfElementsAreNumbers "" = True
checkIfElementsAreNumbers (x : xs)
  | isDigit x = checkIfElementsAreNumbers xs
  | otherwise = False

{-- |
    Valida a senha do Usuario. Uma senha
    eh valida se len(senha) > 5. Retorna
    True caso a senha seja valida, False
    caso contrario.
--}
checkValidSenha :: String -> Bool
checkValidSenha senha = length senha > 5

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

-- | Prompt user
invalidId :: IO () -> IO ()
invalidId f = do
  putStrLn "\nID incorreto!"
  f

-- | Escreve algum dado no Banco de dados.
writeDB :: String -> String -> String -> IO ()
writeDB cpf senha path = do
  let finalPath = "app/database/" ++ path ++ "/" ++ cpf ++ ".txt"
  writeFile finalPath senha

-- | Salva informacoes do usuario que esta atualmente logado no BD.
saveCurrentUser :: String -> IO ()
saveCurrentUser cpf = do
  let finalPath = "app/database/currentUser.txt"
  writeFile finalPath cpf

-- | Dado uma String str, remove todos os '\n' e retorna a nova string. 
removeNewLine :: String -> String
removeNewLine str = [ch | ch <- str, ch /= '\n']

-- | Substitui todos os espacos por underscores
replaceSpaceWithUnderscore :: String -> String
replaceSpaceWithUnderscore "" = ""
replaceSpaceWithUnderscore (x : xs)
  | x == ' ' = '_' : replaceSpaceWithUnderscore xs
  | otherwise = x : replaceSpaceWithUnderscore xs

-- | Recupera a comando do usuario
getComanda :: IO ()
getComanda = do
  cpf <- readFile "app/database/currentUser.txt"
  let valorComandaPath = "app/database/valorComanda/" ++ cpf ++ ".txt"
  let comandaPath = "app/database/comanda/" ++ cpf ++ ".txt"
  valorComanda <- readFile valorComandaPath
  comanda <- readFile comandaPath

  putStrLn ("Valor total: " ++ valorComanda ++ "\n" ++ comanda)

-- | Adiciona uma compra do usuario
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
