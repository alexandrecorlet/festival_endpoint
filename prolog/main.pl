menuBoasVindas():-
  nl,
  print('Seja bem-vindo ao Festival Endpoint!'), nl,
  print('Você já possui uma conta?'), nl, nl,
  print('(1) - Sim'), nl,
  print('(2) - Não'), nl.

menuBoasVindasHandler():-
  menuBoasVindas(),
  nl,
  read(I),
  (I is 1 -> print('positivo'), nl; 
  I is 2 -> print('negativo'), nl;
  write('ERRO!'), nl).

main:-
  menuBoasVindasHandler().
