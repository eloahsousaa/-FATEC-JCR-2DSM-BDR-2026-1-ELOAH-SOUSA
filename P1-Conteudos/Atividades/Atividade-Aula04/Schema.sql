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
VALUES ('Queimada', 'Incêndio de grandes proporções em áreas urbanas ou rurais.'); 


INSERT INTO Localizacao (latitude, longitude, cidade, estado) 
VALUES (-23.305, -45.965, 'Jacareí', 'SP'); 


INSERT INTO Usuario (nome, email, senhaHash) 
VALUES ('Maria Oliveira', 'maria.oliveira@email.com', '2b6c7f64f76b09d0a7b9e...');


INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) 
VALUES ('Queimada em área de preservação', 'Fogo se alastrando na mata próxima à represa.', '2025-08-15 14:35:00', 'Ativo', 1, 1); 


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