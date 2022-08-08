:- module(util, [getDadosConta/2, validarLogin/2]).

getDadosConta(Cpf, Senha):-
  write('Digite seu CPF (apenas números)'), 
  read(Cpf),
  write('Digite sua senha (no mínimo 6 caractéres) '), 
  read(Senha).

validarLogin(Cpf, Senha):- 
  validarCpf(Cpf),
  validarSenha(Senha). 

validarSenha(Senha):-
  atom_chars(Senha, List),
  length(List, Length),
  Length > 5. 

validarCpf(Cpf):-
  atom_chars(Cpf, List),
  length(List, Length),
  Length =:= 11, 
  validarCaracteresDoCpf(List). 

validarCaracteresDoCpf([H | []]):- char_type(H, digit). 
validarCaracteresDoCpf([H | T]):- 
  char_type(H, digit), 
  validarCaracteresDoCpf(T).
  
