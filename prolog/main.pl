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
  printIdDiasDoFestival,
  write('Qual o id do dia do festival?'), nl,
  leString(Id),
  (isValidFestivalId(Id) -> write('TODO'), nl;
  write('ID incorreto!'), nl,
  write('Chamar menu principal prompt'), nl). 

listarAtracoesFestival:-
  % TODO: LER ATRACOES DO .TXT
  write('ATRACOES'), nl,
  write('chamar menu principal prompt').

consultarAtracaoFestival:-
  nl,
  write('Digite o nome da atração: '),
  leString(A),
  formatarAtracao(A, AtracaoFormatada),
  %TODO: CRIAR PATH PARA .TXT DA ATRACAO FORMATADA.
  %TODO: LER .TXT
  write('INFO DA atração'), nl,
  write('Chamar menu principal prompt').

consultarDiaDoFestival:-
  nl,
  printIdDiasDoFestival,
  write('Digite o id do dia do festival que deseja consultar: '), 
  nl,
  leString(Id),
  (isValidFestivalId(Id) -> write('TODO'), nl;
  write('ID incorreto!'), nl,
  write('Chamar menu principal prompt'), nl).

main:-
  menuBoasVindasHandler().
