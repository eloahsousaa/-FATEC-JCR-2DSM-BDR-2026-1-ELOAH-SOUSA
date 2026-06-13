-- EXERCICIO AULA 13 --

-- Exercicio 1 --

CREATE VIEW vw_titulo_paginas_livro AS
SELECT titulo, num_paginas
FROM livro;

SELECT * FROM vw_titulo_paginas_livro;

-- Exercicio 2 --

CREATE VIEW vw_autor_livro AS
SELECT a.nome, COUNT(l.titulo) AS livros_por_autor
FROM autor a
JOIN livro l
ON a.id_autor = l.id_autor
GROUP BY a.nome
HAVING COUNT(l.titulo) > 1;

SELECT * FROM vw_autor_livro;

-- Exercicio 3 --

CREATE VIEW vw_livro_media_paginas AS
SELECT titulo, num_paginas
FROM livro
WHERE num_paginas > (SELECT AVG(num_paginas) FROM livro);

SELECT * FROM vw_livro_media_paginas;

-- Exercicio 4 --

CREATE VIEW vw_autor_livro_ano AS
SELECT a.nome, l.titulo, l.ano_publicacao
FROM autor a
JOIN livro l
ON a.id_autor = l.id_autor;

SELECT * FROM vw_autor_livro_ano;

-- Exercicio 5 --

CREATE VIEW vw_autor_livros_maximo_paginas AS
SELECT a.nome, COUNT(l.id_livro) AS total_livros, MAX(l.num_paginas) AS maior_numero_paginas
FROM autor a
LEFT JOIN livro l
ON a.id_autor = l.id_autor
GROUP BY a.nome, a.id_autor;

SELECT * FROM vw_autor_livros_maximo_paginas;