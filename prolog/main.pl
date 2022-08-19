:- ['./util.pl'].
:- include('./cliente.pl').


setup_bd_cliente :-
	consult('./data/bd_clientes.pl').

setup_bd_festival :-
	consult('./data/bd_festival.pl').

setup_bd_atracoes :-
	consult('./data/bd_atracoes.pl').

setup_bd_ingressos :- 
  consult('./data/bd_ingressos.pl').

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
  setup_bd_cliente,
  nl,

  checkCpfAndSenha(Cpf, Senha),
  write('Você é maior de idade (S/N)? '),
  leString(Resp),



  % if
  (isValidCpfAndSenha(Cpf, Senha)
    ->
    (get_cpfs_clientes(Cpfs), member(Cpf, Cpfs) -> nl, writeln("Cpf já cadastrado."), nl,menuCriarConta;
	assertz(cliente(Cpf, Senha, Resp)),
	adicionaCliente,
	writeln("Cliente cadastrado com sucesso!"),nl),
     nl, write('CONTA CRIADA!'), nl, menuPrincpalHandler;                       % TODO: REGISTRAR USER NO DB

  % else
  write('CAMPOS INVÁLIDO!'), nl,
  menuCriarConta).

get_cpfs_clientes(Cpfs) :- 
	findall(Cpf, cliente(Cpf,_,_), Cpfs).

arquivo_vazio :-
	\+(predicate_property(cliente(_,_,_), dynamic)).

adicionaIngresso :-
  setup_bd_ingressos,
  tell('./data/bd_ingressos.pl'), nl,
  listing(ingresso/2),
  told.

adicionaCliente :-
	setup_bd_cliente,
	tell('./data/bd_clientes.pl'), nl,
	listing(cliente/3),
	told.

menuLogin:-
  nl,
  checkCpfAndSenha(Cpf, Senha),
  % if
  (isValidCpfAndSenha(Cpf, Senha)
    ->
    (login_cliente(Cpf, Senha) ->  menuPrincpalHandler); 
    nl, write('LOGIN REALIZADO COM SUCESSO!'), nl, menuPrincpalHandler;                       % TODO: REGISTRAR USER NO DB

  % else
  write('CAMPOS INVÁLIDO!'), nl,
  menuLogin).

menuComprarIngresso:-
  nl,
  printIdDiasDoFestival,
  write('Qual o id do dia do festival?'), nl,
  leString(Id),

  (isValidFestivalId(Id) -> assertz(ingresso("cu", Id)),
  adicionaIngresso, nl,
  write('Ingresso comprado!'), nl,
  menuPrincpalHandler;
  	
  write('ID incorreto!'), nl,
  write('Chamar menu principal prompt'), nl). 

listarAtracoesFestival:-

	setup_bd_festival,
	findall((N,M,O), festival(N, M, O), ListaClientes), nl,
	writeln("Festivais cadastrados: "),
	exibeClientes(ListaClientes),
	told, nl, 
	fimListagemClientes,
  menuPrincpalHandler.

fimListagemClientes:-
	writeln("Clique em enter para continuar: "),
	read_line_to_string(user_input, _).

exibeClientes([]) :-
	nl,
	writeln("Nenhum usuário cadastrado.").

exibeClientes([H]) :-
	write("- "),
	writeln(H).

exibeClientes([H|T]) :-
	write("- "),
	writeln(H),
	exibeClientes(T).

consultarAtracaoFestival:-
  setup_bd_atracoes,
  nl,
  write('Digite o nome da atração: '),
  leString(Nome),
  %formatarAtracao(Nome, AtracaoFormatada),
  write('INFO DA atração'), nl,
  (get_cpfs_clientes(Nomes), member(Nome, Nomes) -> nl, writeln("Atracao nao encontrada."), nl,menuCriarConta;
	findall((Palco, Horario,Nome,Genero), atracao(Palco, Horario, Nome, Genero), Atracao),
  exibeClientes(Atracao),nl),
  menuPrincpalHandler.

consultarDiaDoFestival:-
  setup_bd_festival,
  nl,
  %printIdDiasDoFestival,
  write('Digite o id do dia do festival que deseja consultar: '), 
  nl,
  leString(Dia),
  (isValidFestivalId(Dia) ->   (get_cpfs_clientes(Dias), member(Dia, Dias) -> nl, writeln("Dia nao encontrado."), nl,menuCriarConta;
	findall((Palco, Horario,Nome,Genero), festival(Palco, Horario, Nome, Genero), Festival),
  exibeClientes(Festival),nl),
  write('Chamar menu principal prompt');
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
    write('Voce tem mais de 18 anos? (S/N): '),
    leString(Resp),
    printProdutosMenoridade,
    nl,
    maiorIdade(Resp, "S") -> printProdutosMaioridade;
  Opcao =:= "2" ->
    % OPCAO 2 
    %TODO: BUSCAR O EXTRATO DO USER NO EM SEU RESPECTIVO .TXT
    nl,
    write('TODO');
  Opcao =:= "3" ->
    % OPCAO 3
    menuPrincpalHandler;

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
