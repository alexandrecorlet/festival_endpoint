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
  leString(I), 
  (I =:= "1" -> write('TODO'), nl;                               % menu login 
  I =:= "2" -> menuCriarConta, nl;                               % menu criar conta
  I =:= "3" -> abort;                                            % encerra execucao
  write('OPÇÃO INVÁLIDA!'), nl,                                  % opcao invalida
  menuBoasVindasHandler).

menuCriarConta:-
  nl,
  login(Cpf, Senha),
  write('Você é maior de idade (S/N)? '),
  leString(Resp),

  % if
  (isValidLogin(Cpf, Senha)
    -> nl, write('CONTA CRIADA!'), nl;                       % TODO: REGISTRAR USER NO DB

  % else
  write('LOGIN INVÁLIDO!'), nl,
  menuCriarConta).

menuComprarIngresso:-
  nl,
  write('Qual o id do dia do festival?'), nl,
  leString(Id),
  (ingressoValido(Id) -> write('TODO'), nl;
  write('ID incorreto!'), nl,
  write('Chamar menu principal prompt'), nl). 

listarAtracoesFestival:-
  % TODO: LER ATRACOES DO .TXT
  write('ATRACOES'), nl,
  write('chamar menu principal prompt').

main:-
  menuBoasVindasHandler().
