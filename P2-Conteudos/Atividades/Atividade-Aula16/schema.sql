-- EXERCICIO AULA 16 --

ALTER TABLE livro
ADD COLUMN quantidade INTEGER DEFAULT 5;

CREATE TABLE log_livro (
id_log SERIAL PRIMARY KEY,
titulo VARCHAR(100),
quantidade_antiga INTEGER,
quantidade_nova INTEGER,
data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM log_livro;

-- Exercicio 1 --

CREATE OR REPLACE FUNCTION
bloquear_exclusao()
RETURNS TRIGGER
AS $$
BEGIN
IF OLD.quantidade > 0 THEN
RAISE EXCEPTION
'Há livros, impossivel deletar!';
END IF;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_exclusao
BEFORE DELETE
ON livro
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao();

-- Exercicio 2 --

CREATE OR REPLACE FUNCTION
log_exclusao_livro()
RETURNS TRIGGER
AS $$
BEGIN
INSERT INTO log_livro(titulo, quantidade_antiga, quantidade_nova)
VALUES (OLD.titulo, OLD.quantidade, 0);
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_exclusao
AFTER DELETE
ON livro
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_livro();

-- Exercicio 3 --

CREATE OR REPLACE FUNCTION
validar_limite_estoque()
RETURNS TRIGGER
AS $$
BEGIN
IF NEW.quantidade > 100 THEN
RAISE EXCEPTION
'Limite atingido!';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_limite
BEFORE UPDATE
ON livro
FOR EACH ROW
EXECUTE FUNCTION validar_limite_estoque();

-- Exercicio 4 --

-- A. BEFORE serve para validação ANTES de alterar ou excluir algo, AFTER serve para registro de mudanças e criações --

-- B. BEFORE --

-- C. AFTER --

-- D. Porque não adianta fazer um registro no Before, se talvez a alteração seja negada pela validação, e não adianta validar no After, se a mudança/exclusão já terá acontecido --

-- Exercicio 5 --

-- A. Caso alguém consiga injetar SQL direto no banco, não haveria segurança alguma --

-- B. Menos encargo para o Backend, mais segurança de que mesmo burlando o Backend, ainda haverá validação/registro, com um banco autoprotegido --

-- C. Padronizam, protegem, registram automaticamente ações, prevenindo erros e esquecimentos --

-- D. Um registro de acessos de uma página por exemplo, usaria um Trigger After, para registrar logs de acesso --
-- Já se um cliente fosse fazer uma compra em uma loja virtual, ao comprar, seria usado um Trigger Before para verificar o estoque, caso o estoque esteja em 0, a operação seria abortada --