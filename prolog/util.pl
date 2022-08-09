- module(util, [login/2, isValidLogin/2, catalogoItensCompletos/2, catalogoItensIncompletos/2, leString/2]).

leString(S):- read_line_to_string(user_input, S).

login(Cpf, Senha):-
  write('Digite seu CPF (apenas números): '), 
  leString(Cpf),
  write('Digite sua senha (no mínimo 6 caractéres): '), 
  leString(Senha).

isValidLogin(Cpf, Senha):- 
  isValidCpf(Cpf),
  isValidSenha(Senha). 

isValidSenha(Senha):-
  atom_chars(Senha, List),
  length(List, Length),
  Length > 5. 

isValidCpf(Cpf):-
  atom_chars(Cpf, List),
  length(List, Length),
  Length =:= 11, 
  checkCaracteresDoCpf(List). 

checkCaracteresDoCpf([H | []]):- char_type(H, digit). 
checkCaracteresDoCpf([H | T]):- 
  char_type(H, digit), 
  checkCaracteresDoCpf(T).

isValidFestivalId(X):- member(X, ["L1", "L2", "L3", "R1", "R2", "R3"]).

formatarAtracao(A, Result):- 
  split_string(A, " ", "", List),
  atomics_to_string(List, "_", Result).

printIdDiasDoFestival:-
  write('* Id dos dias do LolaPalluisa:'), nl,
  write('  (L1) Dia 1'), nl, 
  write('  (L2) Dia 2'), nl, 
  write('  (L3) Dia 3'), nl, 
  nl,
  write('* Id dos dias do Rocha no River:'), nl,
  write('  (R1) Dia 1'), nl,
  write('  (R2) Dia 2'), nl,
  write('  (R3) Dia 3'), nl,
  nl.

printMenuComandaOnline:-
  write('(1) Comprar produtos'), nl,
  write('(2) Consultar extrato'), nl,
  write('(3) Menu principal'), nl, 
  nl.

printProdutosMenoridade:-
  write('(0) Coxinha de Frango 300g - 20R$'), nl,
  write('(1) Água 300ml - 11R$'), nl,
  write('(2) Refrigerante 300ml - 11R$'), nl,
  write('(3) Boné do festival - 100R$'), nl,
  write('(4) Pizza de calabresa 300g - 20R$'), nl.

printProdutosMaioridade:-
  printProdutosMenoridade,
  write('(5) Cerveja 300ml - 10R$'), nl,
  write('(6) Cachaça 100ml - 35R$'), nl,
  write('(7) Pitu 100ml - 70R$'), nl,
  write('(8) Pinga 95ml - 80R$'), nl.

