DROP DATABASE IF EXISTS howlz;
CREATE DATABASE IF NOT EXISTS howlz;
USE howlz;

CREATE TABLE Empresa (
	idEmpresa INT AUTO_INCREMENT,
	razaoSocial VARCHAR(100),
	nomeFantasia VARCHAR(100),
	apelido VARCHAR(100),
	cnpj CHAR(18),
	PRIMARY KEY (idEmpresa)
);

CREATE TABLE TipoUsuario (
	idTipoUsuario INT AUTO_INCREMENT,
	nome VARCHAR(45),
	PRIMARY KEY (idTipoUsuario)
);

CREATE TABLE Usuario (
	idUsuario INT AUTO_INCREMENT,
	nome VARCHAR(100),
	email VARCHAR(100),
	senha VARCHAR(45),
	dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
	fkEmpresa INT,
	fkTipoUsuario INT,
	fkGestor INT,
	PRIMARY KEY (idUsuario)
);

CREATE TABLE Computador (
	idComputador INT AUTO_INCREMENT,
	codigoPatrimonio VARCHAR(100),
	numeroSerial VARCHAR(500),
	sistemaOperacional VARCHAR(150),
	fkEmpresa INT,
	PRIMARY KEY (idComputador)
);

CREATE TABLE AssociacaoComputadorUsuario (
	idAssociacao INT AUTO_INCREMENT,
	fkUsuario INT,
	fkComputador INT,
	dataAssociacao DATETIME,
	dataDesassociacao DATETIME,
	PRIMARY KEY (idAssociacao, fkUsuario, fkComputador)
);

CREATE TABLE Janela (
	idJanela INT AUTO_INCREMENT,
	pid INT,
	comando VARCHAR(150),
	titulo VARCHAR(200),
	visibilidade TINYINT,
	dataHora DATETIME,
	fkComputador INT,
	PRIMARY KEY (idJanela)
);

CREATE TABLE TipoComponente (
	idTipoComponente INT AUTO_INCREMENT,
	nome VARCHAR(45),
	PRIMARY KEY (idTipoComponente)
);

CREATE TABLE UnidadeMedida (
	idUnidadeMedida INT AUTO_INCREMENT,
	nome VARCHAR(45),
	simbolo VARCHAR(7),
	PRIMARY KEY (idUnidadeMedida)
);

CREATE TABLE TipoMonitoramentoComponente (
	idTipoMonitoramentoComponente INT AUTO_INCREMENT,
	nome VARCHAR(45),
	fkTipoComponente INT,
	fkUnidadeMedida INT,
	PRIMARY KEY (idTipoMonitoramentoComponente))
;

CREATE TABLE Componente (
	idComponente INT AUTO_INCREMENT,
	modelo VARCHAR(150),
	identificador VARCHAR(100),
	fkComputador INT,
	fkTipoComponente INT,
	PRIMARY KEY (idComponente)
);

CREATE TABLE MonitoramentoComponente (
	idMonitoramentoComponente INT AUTO_INCREMENT,
	dataHora DATETIME,
	valor DECIMAL(20,2),
	fkTipoMonitoramentoComponente INT,
	fkComponente INT,
	PRIMARY KEY (idMonitoramentoComponente)
);

CREATE TABLE Processo (
	idProcesso INT AUTO_INCREMENT,
	pid INT,
	nome VARCHAR(100),
	dataHora DATETIME,
	fkComputador INT,
	PRIMARY KEY (idProcesso)
);

CREATE TABLE MonitoramentoProcesso (
	idMonitoramentoProcesso INT AUTO_INCREMENT,
	dataHora DATETIME,
	valor DECIMAL(5,2),
	fkProcesso INT,
	fkUnidadeMedida INT,
	fkTipoComponente INT,
	PRIMARY KEY (idMonitoramentoProcesso))
;

CREATE TABLE TipoAlerta (
	idTipoAlerta INT AUTO_INCREMENT,
	nome VARCHAR(45),
	PRIMARY KEY (idTipoAlerta)
);

CREATE TABLE Alerta (
	idAlerta INT AUTO_INCREMENT,
	minimo DECIMAL(20,2),
	maximo DECIMAL(20,2),
	fkTipoAlerta INT,
	fkTipoMonitoramentoComponente INT,
    fkEmpresa INT,
	PRIMARY KEY (idAlerta)
);

-- 	INSERTS OBRIGATÓRIOS:
INSERT INTO TipoUsuario (nome) VALUES 
	('Gestor'), -- FK 1	
	('Colaborador'), -- FK 2
    ('Representante'); -- FK 3
    
INSERT INTO TipoComponente (nome) VALUES 
	('CPU'), -- FK 1	
	('RAM'), -- FK 2
    ('Disco'), -- FK 3
    ('GPU'); -- FK 4

INSERT INTO UnidadeMedida (nome, simbolo) VALUES 
	('Porcentagem', '%'), -- FK 1	
	('Gigabytes', 'GB'), -- FK 2
	('Megabytes', 'MB'), -- FK 3
	('Kilobytes', 'KB'), -- FK 4
	('Bytes', 'B'); -- FK 5

INSERT INTO TipoMonitoramentoComponente (nome, fkTipoComponente, fkUnidadeMedida) VALUES 
	('Uso', 1, 1), -- FK 1	
	('Uso', 2, 1), -- FK 2	
	('Uso', 3, 1), -- FK 3	
	('Uso', 4, 1); -- FK 4

INSERT INTO TipoAlerta (nome) VALUES 
	('Alerta'), -- FK 1	
	('Crítico'); -- FK 2


DELIMITER //

CREATE TRIGGER after_insert_empresa
	AFTER INSERT ON Empresa
	FOR EACH ROW
	BEGIN
		-- Inserir na tabela Alerta com fkEmpresa definido como o novo ID de Empresa
		INSERT INTO Alerta (minimo, maximo, fkTipoAlerta, fkTipoMonitoramentoComponente, fkEmpresa) VALUES 
			(80.00, 89.99, 1, 1, NEW.idEmpresa), -- FK 1 (CPU USO)
			(90.00, 100.00, 2, 1, NEW.idEmpresa),  -- FK 2 (CPU USO)
			(90.00, 94.99, 1, 2, NEW.idEmpresa),  -- FK 3 (RAM USO)
			(95.00, 100.00, 2, 2, NEW.idEmpresa),  -- FK 4 (RAM USO)
			(85.00, 89.99, 1, 3, NEW.idEmpresa),  -- FK 5 (DISCO USO)
			(90.00, 100.00, 2, 3, NEW.idEmpresa),  -- FK 6 (DISCO USO)
			(80.00, 89.99, 1, 4, NEW.idEmpresa),  -- FK 7 (GPU USO)
			(90.00, 100.00, 2, 4, NEW.idEmpresa);  -- FK 8 (GPU USO)
	END //

DELIMITER ;
