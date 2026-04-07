CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    endereco TEXT,
    telefone VARCHAR(15)
);

INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES 
('João Silva', '12345678900', 'Rua A, 123', '11999990000'),
('Maria Oliveira', '98765432100', 'Rua B, 456', '11988887777');


CREATE TABLE contas (
    id_conta SERIAL PRIMARY KEY,
    numero_conta VARCHAR(10) UNIQUE NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0,
    id_cliente INT REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES 
('000123', 1500.00, 1),
('000456', 2300.00, 2);

CREATE TABLE transacoes (
    id_transacao SERIAL PRIMARY KEY,
    id_conta INT REFERENCES contas(id_conta) ON DELETE CASCADE,
    tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destino_transferencia INT REFERENCES contas(id_conta)
);

INSERT INTO transacoes (id_conta, tipo, valor) VALUES 
(1, 'Depósito', 500.00),
(2, 'Saque', 200.00);

INSERT INTO transacoes (id_conta, tipo, valor, destino_transferencia) VALUES 
(1, 'Transferência', 300.00, 2);


SELECT * FROM clientes;

SELECT c.numero_conta, c.saldo, cl.nome
FROM contas c
INNER JOIN clientes cl ON c.id_cliente = cl.id_cliente;

INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES
('Carlos Souza', '11122233344', 'Rua C, 789', '11977776666');

INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES
('000789', 0.00, 3);

INSERT INTO transacoes (id_conta, tipo, valor, destino_transferencia)
VALUES (1, 'Transferência', 100.00, 3);

-- tira da conta 000123 (id 1)
UPDATE contas
SET saldo = saldo - 100
WHERE id_conta = 1;

-- adiciona na conta 000789 (id 3)
UPDATE contas
SET saldo = saldo + 100
WHERE id_conta = 3;

SELECT numero_conta, saldo
FROM contas;