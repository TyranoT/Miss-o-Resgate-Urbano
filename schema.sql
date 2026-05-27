-- Ativa o suporte a chaves estrangeiras no SQLite
PRAGMA foreign_keys = ON;

-- Tabela CATEGORIA
CREATE TABLE CATEGORIA (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    icone TEXT,
    descricao TEXT
);

-- Tabela PRIORIDADE
CREATE TABLE PRIORIDADE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    peso INTEGER NOT NULL,
    cor_hex TEXT
);

-- Tabela STATUS
CREATE TABLE STATUS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    permite_edicao CHECK (permite_edicao IN (0, 1)) NOT NULL -- SQLite usa 0/1 para booleano
);

-- Tabela BAIRRO
CREATE TABLE BAIRRO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    regiao TEXT
);

-- Tabela RESPONSAVEL
CREATE TABLE RESPONSAVEL (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    setor TEXT,
    contato TEXT
);

-- Tabela CHAMADO
CREATE TABLE CHAMADO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL UNIQUE,
    descricao TEXT,
    categoria_id INTEGER NOT NULL,
    prioridade_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    bairro_id INTEGER NOT NULL,
    responsavel_id INTEGER NOT NULL,
    data_abertura TEXT NOT NULL,      -- SQLite armazena datas como TEXT (ISO8601)
    data_atualizacao TEXT NOT NULL,
    data_conclusao TEXT,
    FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(id),
    FOREIGN KEY (prioridade_id) REFERENCES PRIORIDADE(id),
    FOREIGN KEY (status_id) REFERENCES STATUS(id),
    FOREIGN KEY (bairro_id) REFERENCES BAIRRO(id),
    FOREIGN KEY (responsavel_id) REFERENCES RESPONSAVEL(id)
);

-- Tabela HISTORICO_STATUS
CREATE TABLE HISTORICO_STATUS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chamado_id INTEGER NOT NULL,
    status_anterior_id INTEGER, -- Pode ser nulo no primeiro registro
    status_novo_id INTEGER NOT NULL,
    data_mudanca TEXT NOT NULL,
    observacao TEXT,
    FOREIGN KEY (chamado_id) REFERENCES CHAMADO(id) ON DELETE CASCADE,
    FOREIGN KEY (status_anterior_id) REFERENCES STATUS(id),
    FOREIGN KEY (status_novo_id) REFERENCES STATUS(id)
);
