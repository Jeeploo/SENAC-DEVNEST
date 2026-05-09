-- Script do Banco de Dados - SENAC DEVNEST

-- Tabela: turmas (Criada primeiro para o relacionamento com usuarios funcionar)
CREATE TABLE turmas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    periodo VARCHAR(50)
);

-- Tabela: usuarios
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('aluno', 'professor', 'coordenador', 'empresa') NOT NULL,
    curso VARCHAR(100),
    instituicao VARCHAR(150),
    foto_perfil VARCHAR(255),
    turma_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (turma_id) REFERENCES turmas(id)
);

-- Tabela: projetos
CREATE TABLE projetos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL,
    tecnologias TEXT,
    github_link VARCHAR(255),
    video_demo VARCHAR(255),
    status ENUM('rascunho', 'submetido', 'avaliado') DEFAULT 'rascunho',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (aluno_id) REFERENCES usuarios(id)
);

-- Tabela: arquivos_projeto
CREATE TABLE arquivos_projeto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    projeto_id INT NOT NULL,
    nome_arquivo VARCHAR(255),
    caminho_arquivo VARCHAR(255),
    tipo_arquivo VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
);

-- Tabela: avaliacoes
CREATE TABLE avaliacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    projeto_id INT NOT NULL,
    professor_id INT NOT NULL,
    nota DECIMAL(4,2),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES usuarios(id)
);

-- Tabela: historico_acoes
CREATE TABLE historico_acoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    acao VARCHAR(255) NOT NULL,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabela: comentarios
CREATE TABLE comentarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    projeto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    comentario TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabela: favoritos
CREATE TABLE favoritos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    projeto_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
);

-- Tabela: tecnologias
CREATE TABLE tecnologias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela: projeto_tecnologias
CREATE TABLE projeto_tecnologias (
    projeto_id INT NOT NULL,
    tecnologia_id INT NOT NULL,
    PRIMARY KEY (projeto_id, tecnologia_id),
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    FOREIGN KEY (tecnologia_id) REFERENCES tecnologias(id) ON DELETE CASCADE
);