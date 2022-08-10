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
  (I =:= "1" -> menuLogin, nl;                               % menu login 
  I =:= "2" -> menuCriarConta, nl;                               % menu criar conta
  I =:= "3" -> abort;                                            % encerra execucao
  write('OPÇÃO INVÁLIDA!'), nl,                                  % opcao invalida
  menuBoasVindasHandler).

menuCriarConta:-
  nl,
  checkCpfAndSenha(Cpf, Senha),
  write('Você é maior de idade (S/N)? '),
  leString(Resp),

  % if
  (isValidCpfAndSenha(Cpf, Senha)
    -> nl, write('CONTA CRIADA!'), nl, menuPrincpalHandler;                       % TODO: REGISTRAR USER NO DB

  % else
  write('CAMPOS INVÁLIDO!'), nl,
  menuCriarConta).

menuLogin:-
  nl,
  checkCpfAndSenha(Cpf, Senha),
  % if
  (isValidCpfAndSenha(Cpf, Senha)
    -> nl, write('LOGIN REALIZADO COM SUCESSO!'), nl, menuPrincpalHandler;                       % TODO: REGISTRAR USER NO DB

  % else
  write('CAMPOS INVÁLIDO!'), nl,
  menuLogin).

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

comandaOnlineMenu:-
  nl,
  printMenuComandaOnline,
  write('Digite uma opção: '),
  leString(Opcao),

  (Opcao =:= "1" ->
    % OPCAO 1
    %TODO: VERIFICAR SE O USER EH MAIOR DE IDADE
    %printProdutosMenoridade,
    nl,
    printProdutosMaioridade;
  Opcao =:= "2" ->
    % OPCAO 2 
    %TODO: BUSCAR O EXTRATO DO USER NO EM SEU RESPECTIVO .TXT
    nl,
    write('TODO');
  Opcao =:= "3" ->
    % OPCAO 3
    write('Chamar menu principal prompt');

  % ELSE
  write('OPÇÃO INVÁLIDA!'), nl, 
  write('Chamar menu principal prompt')).

menuPrincpalHandler:-
  nl,
  printMenuPrincipal, nl,
  write('Digite uma opção: '), nl,
  leString(Opcao),

  (Opcao =:= "1" ->
  menuComprarIngresso;

  Opcao =:= "2" ->
  listarAtracoesFestival;

  Opcao =:= "3" ->
  comandaOnlineMenu;

  Opcao =:= "4" ->
  consultarAtracaoFestival;

  Opcao =:= "5" ->
  consultarDiaDoFestival;

  Opcao =:= "6" ->
  write('TODO'), nl, menuPrincpalHandler;


  Opcao =:= "7" ->
  abort).

main:-
  menuBoasVindasHandler().

