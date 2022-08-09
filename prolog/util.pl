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
