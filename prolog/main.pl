:- ['./util.pl'].

menuBoasVindas():-
  nl,
  print('Seja bem-vindo ao Festival Endpoint!'), nl,
  print('Você já possui uma conta?'), nl, nl,
  print('(1) - Sim'), nl,
  print('(2) - Não'), nl,
  print('(3) - Sair'), nl.

menuBoasVindasHandler():-
  menuBoasVindas(),
  nl,
  read(I),
  (I is 1 -> write('TODO'), nl;                              % menu login 
  I is 2 -> write('TODO'), nl;                               % menu criar conta
  I is 3 -> abort;
  write('OPÇÃO INVÁLIDA!'), nl,                              % opcao invalida
  menuBoasVindasHandler).

menuComprarIngresso:-
  nl,
  write('Qual o id do dia do festival?'), nl,
  leString(Id),
  (ingressoValido(Id) -> write('TODO'), nl;
  write('ID incorreto!'), nl,
  write('Chamar menu principal prompt'), nl).               % TODO:call menuPrincipalPrompt

main:-
  menuBoasVindasHandler().
