-- EXERCICIO AULA 14 --

-- Exercicio 1 --

CREATE OR REPLACE PROCEDURE
sp_inserir_livro(
p_titulo VARCHAR,
p_paginas INT,
p_autor INT,
p_ano INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF NOT EXISTS (SELECT id_autor FROM autor WHERE id_autor = p_autor LIMIT 1) THEN
	RAISE EXCEPTION 'Autor não existente!';
	END IF;
	INSERT INTO livro(titulo, num_paginas, id_autor, id_editora, ano_publicacao)
	VALUES (p_titulo, p_paginas, p_autor, p_autor, p_ano);
END;
$$;

-- Exercicio 2 --

CREATE OR REPLACE PROCEDURE
sp_atualizar_paginas(
p_id_livro INT,
p_paginas INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF p_paginas <= 10 THEN
	RAISE EXCEPTION 'Necessário ter mais de 10 páginas';
	END IF;
	UPDATE livro
	SET num_paginas = p_paginas
	WHERE id_livro = p_id_livro;
END;
$$;

-- Exercicio 3 --

CREATE OR REPLACE PROCEDURE
sp_excluir_autor(
p_autor INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF (SELECT COUNT(id_livro) FROM livro WHERE id_autor = p_autor) > 0 THEN
	RAISE EXCEPTION 'Autor tem livros publicados!';
	END IF;
	DELETE FROM autor
	WHERE id_autor = p_autor;
END;
$$;

-- Exercicio 4 --

CREATE OR REPLACE PROCEDURE
sp_autor_media_paginas(
p_autor INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_nome_autor VARCHAR;
	v_media_paginas NUMERIC;
BEGIN
	SELECT a.nome, AVG(l.num_paginas)
	INTO v_nome_autor, v_media_paginas
	FROM autor a
	JOIN livro l
	ON a.id_autor = l.id_autor
	WHERE a.id_autor = p_autor
	GROUP BY a.nome, a.id_autor;

	RAISE NOTICE 'Autor: %, Média de Páginas: %', v_nome_autor, ROUND(v_media_paginas, 2);
END;
$$;

-- Exercicio 5 --

CREATE OR REPLACE PROCEDURE
sp_inserir_livro_validado(
p_titulo VARCHAR,
p_paginas INT,
p_autor INT,
p_ano INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF NOT EXISTS (SELECT id_autor FROM autor WHERE id_autor = p_autor LIMIT 1) THEN
	RAISE EXCEPTION 'Autor não existente!';
	END IF;
	IF LENGTH(p_titulo) <= 0 THEN
	RAISE EXCEPTION 'Título vazio!';
	END IF;
	IF p_paginas <= 0 THEN
	RAISE EXCEPTION 'Página precisa ser maior que 0';
	END IF;
	INSERT INTO livro(titulo, num_paginas, id_autor, id_editora, ano_publicacao)
	VALUES (p_titulo, p_paginas, p_autor, p_autor, p_ano);
END;
$$;

-- Exercicio 6 --

CALL sp_inserir_livro_validado(
'Noites Brancas',
-478,
3,
1945
);

-- ERROR:  Página precisa ser maior que 0 --
-- CONTEXT:  função PL/pgSQL sp_inserir_livro_validado(character varying,integer,integer,integer) linha 10 em RAISE --

-- ERRO:  Página precisa ser maior que 0 --
-- SQL state: P0001 --