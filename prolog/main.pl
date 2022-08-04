
/*                              Predicados Úteis                                  */


stringToList(S, R):- atom_chars(S, R).

checkIfIsListOfNumber([], F):- F is 1.
checkIfIsListOfNumber(F):- F is 0.
checkIfIsListOfNumber([H | T], F):- 
  (number(H) -> checkIfIsListOfNumber(T, F);
  checkIfIsListOfNumber(F)).

convertListOfStringsToListOfInt([], []). 
convertListOfStringsToListOfInt([H|Ts], [Elm|Es]) :-
   string_to_atom(H, Temp),
   (atom_number(Temp, Elm) -> convertListOfStringsToListOfInt(Ts, Es); 
   convertListOfStringsToListOfInt([], [])). 

checkLenOfList(Xs, R) :- checkLenOfList(Xs, 0, R) .
checkLenOfList( [], L, L).
checkLenOfList( [_|Xs], T, R ) :-
  T1 is T+1 ,
  checkLenOfList(Xs, T1, R).

/*      Regra de Negócio     */


checkValidCpf(CPF):- 
  stringToList(CPF, CPFList),
  checkLenOfList(CPFList, LenResult),
  convertListOfStringsToListOfInt(CPFList, R2),
  checkIfIsListOfNumber(R2, F),
  isCpfValid(LenResult, F).

isCpfValid(L, F):-
  (L is 11, F is 1 -> print('CPF COM SUCESSO!'); 
  write('Erro, cpf inválido'), nl).

menuBoasVindasHandler():-
  menuBoasVindas(),
  nl,
  read(I),
  (I is 1 -> nl, menuCriarConta(); 
  I is 2 -> print('negativo'), nl;
  write('ERRO!'), nl).


menuCriarConta():-
  digiteSeuCpfString(), nl,
  read(CPF), nl,
  checkValidCpf(CPF).




/*                                    Strings                                                           */

menuBoasVindas():-
  nl,
  print('Seja bem-vindo ao Festival Endpoint!'), nl,
  print('Você já possui uma conta?'), nl, nl,
  print('(1) - Sim'), nl,
  print('(2) - Não'), nl.

digiteSeuCpfString():-
  print('Digite seu CPF (Apenas números)'), nl.

digiteSuaSenhaString():-
  print('Digite sua senha (no mínimo 6 dígitos)'), nl.

main:-
  menuBoasVindasHandler().
