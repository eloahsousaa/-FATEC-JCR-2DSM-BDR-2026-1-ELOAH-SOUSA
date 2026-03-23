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