setup_bd :-
	consult('./data/bd_clientes.pl').

loginCliente(Cpf, Senha) :-
	nl,
	(cliente(Cpf, Senha, Maior) -> nl, writeln("Login realizado com sucesso!"), nl;
	writeln("Senha incorreta."), nl, menuLogin).

login_cliente(Cpf, Senha) :-
	setup_bd,
	arquivo_vazio -> writeln("Cliente não cadastrado."), nl, false;
	(cliente(_, _, _) -> loginCliente(Cpf, Senha);
	writeln("Cliente não cadastrado."), nl, false),
	fimMetodo.

fimMetodo:-
	writeln("Clique em enter para continuar: "),
	read_line_to_string(user_input, _).