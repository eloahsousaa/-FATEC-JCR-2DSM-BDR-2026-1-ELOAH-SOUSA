CREATE TABLE TipoEvento (
    idTipoEvento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);


CREATE TABLE Localizacao (
    idLocalizacao SERIAL PRIMARY KEY,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    cidade VARCHAR(100),
    estado CHAR(2)
);


CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senhaHash VARCHAR(255) NOT NULL
);


CREATE TABLE Evento (
    idEvento SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    dataHora TIMESTAMP NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    idTipoEvento INT REFERENCES TipoEvento(idTipoEvento),
    idLocalizacao INT REFERENCES Localizacao(idLocalizacao)
);


CREATE TABLE Relato (
    idRelato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    dataHora TIMESTAMP NOT NULL,
    idEvento INT REFERENCES Evento(idEvento),
    idUsuario INT REFERENCES Usuario(idUsuario)
);


CREATE TABLE Alerta (
    idAlerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    dataHora TIMESTAMP NOT NULL,
    nivel VARCHAR(50) CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    idEvento INT REFERENCES Evento(idEvento)
);


CREATE TABLE historico_evento (
    idHistorico SERIAL PRIMARY KEY,
    idEvento INT REFERENCES Evento(idEvento),
    dataAlteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statusAnterior VARCHAR(50)
);

INSERT INTO TipoEvento (nome, descricao) 
VALUES ('Queimada', 'Incêndio de grandes proporções em áreas urbanas ou rurais.'), 
('Enchente', 'Alagamento causado por chuvas intensas.'),
('Deslizamento', 'Queda de terra em áreas de encosta.');


INSERT INTO Localizacao (latitude, longitude, cidade, estado) 
VALUES (-23.305, -45.965, 'Jacareí', 'SP'),
(-23.550, -46.633, 'São Paulo', 'SP'),
(-22.906, -43.172, 'Rio de Janeiro', 'RJ');


INSERT INTO Usuario (nome, email, senhaHash) 
VALUES ('Maria Oliveira', 'maria5@email.com', 'hash779'),
('João Silva', 'joao.silva1@email.com', 'hash223'),
('Ana Souza', 'ana.souza3@email.com', 'hash656');


INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) 
VALUES ('Queimada em área de preservação', 'Fogo se alastrando na mata próxima à represa.', '2025-08-15 14:35:00', 'Resolvido', 1, 1), 
('Enchente no centro', 'Ruas alagadas após chuva forte.', '2025-09-10 10:00:00', 'Em Monitoramento', 2, 2),
('Deslizamento em morro', 'Terra cedeu após dias de chuva.', '2025-09-12 08:30:00', 'Ativo', 3, 3);


INSERT INTO Relato (texto, dataHora, idEvento, idUsuario) 
VALUES ('Fumaça intensa e chamas visíveis a partir da rodovia.', '2025-08-15 15:10:00', 1, 1);


INSERT INTO Alerta (mensagem, dataHora, nivel, idEvento) 
VALUES ('Evacuação imediata da área próxima à represa.', '2025-08-15 15:20:00', 'Crítico', 1); 

select * from TipoEvento
select * from Localizacao
select * from Usuario
select * from Evento
select * from Relato
select * from Alerta

select nome, email from Usuario;

select titulo, status from Evento;

select * from Evento
where status = 'Ativo';

select * from Usuario
where nome like 'Ana%';


INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) 
VALUES 
('Nova enchente', 'Alagamento após chuva forte', '2025-10-01 09:00:00', 'Ativo', 2, 1),
('Queimada leve', 'Fogo controlado rapidamente', '2025-10-02 14:00:00', 'Resolvido', 1, 2);

SELECT * 
FROM Evento
ORDER BY dataHora DESC;

SELECT titulo, dataHora, status
FROM Evento
ORDER BY dataHora DESC
LIMIT 3;


SELECT COUNT(*) AS total_usuarios
FROM Usuario;

SELECT idTipoEvento, COUNT(*) AS total_eventos
FROM Evento
GROUP BY idTipoEvento;

SELECT 
MIN(dataHora) AS mais_antigo,
MAX(dataHora) AS mais_recente
FROM Evento;

SELECT AVG(total) 
FROM (
SELECT COUNT(*) AS total
FROM Evento e
JOIN Localizacao l ON e.idLocalizacao = l.idLocalizacao
GROUP BY cidade
) sub;

SELECT cidade, COUNT(*) AS total_eventos
FROM Evento e
JOIN Localizacao l ON e.idLocalizacao = l.idLocalizacao
GROUP BY cidade;




SELECT e.titulo, t.nome AS tipo_evento
FROM Evento e
INNER JOIN TipoEvento t 
ON e.idTipoEvento = t.idTipoEvento;

SELECT e.titulo, l.cidade, l.estado
FROM Evento e
INNER JOIN Localizacao l 
ON e.idLocalizacao = l.idLocalizacao;

SELECT e.titulo, t.nome AS tipo_evento, l.cidade
FROM Evento e
LEFT JOIN TipoEvento t 
ON e.idTipoEvento = t.idTipoEvento
LEFT JOIN Localizacao l 
ON e.idLocalizacao = l.idLocalizacao;

SELECT e.titulo, l.cidade, l.estado
FROM Localizacao l
RIGHT JOIN Evento e 
ON e.idLocalizacao = l.idLocalizacao;

SELECT l.cidade, COUNT(*) AS total_eventos
FROM Evento e
JOIN Localizacao l 
ON e.idLocalizacao = l.idLocalizacao
GROUP BY l.cidade;