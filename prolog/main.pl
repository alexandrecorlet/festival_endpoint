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

setup_bd_itens :- 
  consult('./data/bd_itens.pl').

setup_bd_comanda :- 
  consult('./data/bd_comandas.pl').

  

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
  (I =:= "1" -> menuLogin, nl;                               
  I =:= "2" -> menuCriarConta, nl;                          
  I =:= "3" -> abort;                                      
  write('OPÇÃO INVÁLIDA!'), nl,                           
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
    (get_list(Cpfs), member(Cpf, Cpfs) -> nl, writeln("Cpf já cadastrado."), nl,menuCriarConta;
	assertz(cliente(Cpf, Senha, Resp)),
	adicionaCliente,
	writeln("Cliente cadastrado com sucesso!"),nl),
     nl, write('CONTA CRIADA!'), nl, 
     menuPrincipalHandler(Cpf);                       

  % else
  write('CAMPOS INVÁLIDO!'), nl,
  menuCriarConta).

get_list(Cpfs) :- 
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

adicionaComanda :-
	setup_bd_comanda,
	tell('./data/bd_comandas.pl'), nl,
	listing(comanda/5),
	told.

menuLogin:-
  nl,
  checkCpfAndSenha(Cpf, Senha),

  % if
  (isValidCpfAndSenha(Cpf, Senha)
    ->
    (login_cliente(Cpf, Senha) -> menuPrincipalHandler(Cpf)),
    nl, 
    nl, menuPrincipalHandler(Cpf);                     

  % else
  nl,
  write('CAMPOS INVÁLIDO!'), nl, menuLogin).

menuComprarIngresso(Cpf):-
  nl,
  printIdDiasDoFestival,
  write('Qual o id do dia do festival?'), nl,
  leString(Id),

  (isValidFestivalId(Id) -> assertz(ingresso(Cpf, Id)),                              % CPF e Id do FESTIVAL
  adicionaIngresso, 
  nl,
  writeln('Ingresso comprado!'), nl,
  menuPrincipalHandler(Cpf);
  	
  nl,
  writeln('ID incorreto!'), nl,
  menuPrincipalHandler(Cpf)). 

listarAtracoesFestival(Cpf):-

	setup_bd_festival,
	findall((N,M,O,C), festival(N, M, O,C), ListaFestivais), nl,
	writeln("Festivais cadastrados: "),
	exibeLista(ListaFestivais),
	told, 
  menuPrincipalHandler(Cpf).

fimListagemClientes:-
	writeln("Clique em enter para continuar: "),
	read_line_to_string(user_input, _).

exibeLista([]) :-
	nl,
	writeln("Nada encontrado.").

exibeLista([H]) :-
	write("- "),
	writeln(H).

exibeLista([H|T]) :-
	write("- "),
	writeln(H),
	exibeLista(T).

consultarAtracaoFestival(Cpf):-
  setup_bd_atracoes,
  nl,
  write('Digite o nome da atração: '),
  leString(Nome),
  %formatarAtracao(Nome, AtracaoFormatada),
  write('INFO DA atração'), nl,
  (get_list(Nomes), member(Nome, Nomes) -> nl, writeln("Atracao nao encontrada."), nl,menuCriarConta;
	findall((Palco, Horario,Nome,Genero), atracao(Palco, Horario, Nome, Genero), Atracao),
  exibeLista(Atracao),nl),
  menuPrincipalHandler(Cpf).

consultarDiaDoFestival(Cpf):-
  setup_bd_festival,
  nl,
  printIdDiasDoFestival,
  write('Digite o id do dia do festival que deseja consultar: '), 
  nl,
  leString(Dia),
  (get_list(Dias), member(Dia, Dias) -> nl, writeln("Nada foi encontrado"), nl,menuPrincipalHandler(Cpf);
	findall((A, B,C,Dia), festival(A, B, C, Dia), Festival),
  exibeLista(Festival),nl),
  menuPrincipalHandler(Cpf).

comandaOnlineMenu(Cpf):-
  setup_bd_cliente,
  findall((Maior), cliente(Cpf, _, Maior), DeMaior ),
  nl, 
  printMenuComandaOnline,
  write("Escolha uma opcao: "),
  leString(Opcao),

  (Opcao =:= "1" ->
    compraOnline(Cpf, IdProduto, Quantidade, DeMaior);
    
  Opcao =:= "2" ->
    getComanda(Cpf);

  Opcao =:= "3" ->
    menuPrincipalHandler(Cpf);

  write("OPCAO INVALIDA!"),
  menuPrincipalHandler(Cpf)).

compraOnline(Cpf, IdProduto, Quantidade,[DeMaior]):-
    setup_bd_itens,
    nl,

    DeMaior =:= "S" -> 
      printProdutosMaioridade,

      write("Digite o ID do produto: "),
      leString(IdProduto),
      write("Digite a quantidade que deseja: "),
      leString(Quantidade),

      comprar(IdProduto, Quantidade,Cpf),
      write("Compra realizada!"),
      menuPrincipalHandler(Cpf);

    printProdutosMenoridade,

    write("Digite o ID do produto: "),
    leString(IdProduto),
    write("Digite a quantidade que deseja: "),
    leString(Quantidade),
    
    atom_number(IdProduto, Y),
    Y > 4 -> nl,write("Codigo invalido"),nl,menuPrincipalHandler(Cpf);

    comprar(IdProduto, Quantidade,Cpf);
    write("Compra realizada!"),
    menuPrincipalHandler(Cpf).


comprar(IdProduto, Quantidade, Cpf):-
  setup_bd_itens,
  nl,
  
  atom_number(IdProduto, Y),
  Y > 7 -> nl,write("Codigo invalido"),nl,menuPrincipalHandler(Cpf);
  
  findall((Nome), item(IdProduto, Nome,_,_), [NomeProd] ),
  findall((Preco), item(IdProduto, _,_, Preco), [PrecoProd] ),

  atom_number(Quantidade,QuantidadeInt),
  PrecoFinal is PrecoProd*QuantidadeInt,

  assertz(comanda(Cpf, NomeProd, PrecoProd, Quantidade, PrecoFinal)),
  adicionaComanda.

getComanda(Cpf):-
  setup_bd_comanda,
  nl,
  TempCpf =Cpf,

  findall((Nome), comanda(TempCpf, Nome,_,_,_), NomeList ),
  findall((PrecoInd), comanda(TempCpf, _,PrecoInd,_,_), PrecoIndList ),
  findall((Quantidade), comanda(TempCpf, _,_,Quantidade,_), QuantidadeList ),
  findall((ValorTotal), comanda(TempCpf, _,_,_,ValorTotal), ValorTotalList ),

  exibirComanda(NomeList,PrecoIndList,QuantidadeList,ValorTotalList,Cpf).


exibirComanda([], [], [], [],Cpf):-
	writeln("Nenhuma compra cadastrada."), 
	nl,
	menuPrincipalHandler(Cpf).

exibirComanda([N], [PI], [Q], [PF],Cpf):-
	write("Produto: "),
	write(N),
	write(" Preco individual: "),
	write(PI),
  write(" Quantidade: "),
	write(Q),
  write(" Preco total: "),
	write(PF),
	nl,
	menuPrincipalHandler(Cpf).

exibirComanda([N|TN], [PI|TPI], [Q|TQ], [PF|TPF],Cpf):-
	write("Produto: "),
	write(N),
	write(" Preco individual: "),
	write(PI),
  write(" Quantidade: "),
	write(Q),
  write(" Preco total: "),
	write(PF),
	nl,
	exibirComanda(TN,TPI,TQ,TPF,Cpf).


consultarAtracaoPorData(Cpf):-
  setup_bd_festival,
  write('Digite a data inicial: '), nl,
  leString(Data_inicial), split_string(Data_inicial, "/", "", Inicio), nl,
  converte(Inicio, Inicios),
  date(Inicios, Int_inicial),

  write('Digite a data final: '), nl,
  leString(Data_final), split_string(Data_final, "/", "", Final),nl,
  converte(Final, Finals),
  date(Finals, Int_final),

  findall((D), festival(N, M, D,C), ListaDatas),
  findall((N,M,O,C), festival(N, M, O,C), ListaFestivais),

  exibirDatas(ListaDatas,Int_inicial,Int_final,ListaFestivais),

  menuPrincipalHandler(Cpf).


date([D, M, A], Dias) :- Dias is D + M * 30 + A * 365.

converte([], []).
converte([X | Xs], [Y | Ys]):-
  atom_number(X, Y),
  converte(Xs, Ys).

exibirDatas([], Data_inicial, Data_final,[]):-
	writeln("Nenhuma data encontrada."), 
	nl.

exibirDatas([D], Data_inicial, Data_final,[F]):-

  split_string(D, "/", "", Comparacao),

  converte(Comparacao, Comparacoes),
  date(Comparacoes, Int_comparaco),


  Int_comparaco>Data_inicial,Int_comparaco<Data_final -> writeln(F);
	nl.

exibirDatas([D|TD], Data_inicial, Data_final, [F|TF]):-

  split_string(D, "/", "", Comparacao),

  converte(Comparacao, Comparacoes),
  date(Comparacoes, Int_comparacao),

  Int_comparacao>Data_inicial,Int_comparacao<Data_final -> writeln(F),exibirDatas(TD, Data_inicial, Data_final,TF);

  exibirDatas(TD, Data_inicial, Data_final,TF).

menuPrincipalHandler(Cpf):-
  nl,
  printMenuPrincipal, nl,
  write('Digite uma opção: '), nl,
  leString(Opcao),

  (Opcao =:= "1" ->
  menuComprarIngresso(Cpf);

  Opcao =:= "2" ->
  listarAtracoesFestival(Cpf);

  Opcao =:= "3" ->
  comandaOnlineMenu(Cpf);

  Opcao =:= "4" ->
  consultarAtracaoFestival(Cpf);

  Opcao =:= "5" ->
  consultarDiaDoFestival(Cpf);

  Opcao =:= "6" ->
  consultarAtracaoPorData(Cpf);


  Opcao =:= "7" ->
  abort;
  
  write("OPCAO INVALIDA!"),
  menuPrincipalHandler(Cpf)
  ).

main:-
  menuBoasVindasHandler().
