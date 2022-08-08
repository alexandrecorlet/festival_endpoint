- module(util, [login/2, isValidLogin/2]).

login(Cpf, Senha):-
  write('Digite seu CPF (apenas números)'), 
  read(Cpf),
  write('Digite sua senha (no mínimo 6 caractéres) '), 
  read(Senha).

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

