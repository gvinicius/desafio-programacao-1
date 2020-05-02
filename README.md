# Desafio de programação 1
A idéia deste desafio é nos permitir avaliar melhor as habilidades de candidatos à vagas de programador, de vários níveis.

Este desafio deve ser feito por você em sua casa. Gaste o tempo que você quiser, porém normalmente você não deve precisar de mais do que algumas horas.

## Instruções de entrega do desafio
1. Primeiro, faça um fork deste projeto para sua conta no Github (crie uma se você não possuir).
1. Em seguida, implemente o projeto tal qual descrito abaixo, em seu próprio fork.
1. Por fim, empurre todas as suas alterações para o seu fork no Github e envie um pull request para este repositório original. Se você já entrou em contato com alguém da Nexaas sobre uma vaga, avise também essa pessoa por email, incluindo no email o seu usuário no Github.

## Instruções alternativas de entrega do desafio (caso você não queira que sua submissão seja pública)
1. Faça um clone deste repositório.
1. Em seguida, implemente o projeto tal qual descrito abaixo, em seu clone local.
1. Por fim, envie via email um arquivo patch para seu contato na Nexaas.

## Descrição do projeto
Você recebeu um arquivo de texto com os dados de vendas da empresa. Precisamos criar uma maneira para que estes dados sejam importados para um banco de dados.

Sua tarefa é criar uma interface web que aceite upload de arquivos, normalize os dados e armazene-os em um banco de dados relacional.

Sua aplicação web DEVE:

1. Aceitar (via um formulário) o upload de arquivos separados por TAB com as seguintes colunas: purchaser name, item description, item price, purchase count, merchant address, merchant name. Você pode assumir que as colunas estarão sempre nesta ordem, que sempre haverá dados em cada coluna, e que sempre haverá uma linha de cabeçalho. Um arquivo de exemplo chamado example_input.tab está incluído neste repositório.
1. Interpretar ("parsear") o arquivo recebido, normalizar os dados, e salvar corretamente a informação em um banco de dados relacional.
1. Exibir a receita bruta total representada pelo arquivo enviado após o upload + parser.
1. Ser escrita obrigatoriamente em Ruby 2.0+, Python 2.7+, Java 7+ ou PHP 5.3+ (caso esteja entrevistando para uma vaga específica, utilize a linguagem solicitada pela vaga).
1. Ser simples de configurar e rodar, funcionando em ambiente compatível com Unix (Linux ou Mac OS X). Ela deve utilizar apenas linguagens e bibliotecas livres ou gratuitas.

Sua aplicação web não precisa:

1. Lidar com autenticação ou autorização (pontos extras se ela fizer, mais pontos extras se a autenticação for feita via OAuth).
1. Ser escrita usando algum framework específico (mas não há nada errado em usá-los também, use o que achar melhor).
1. Ter uma aparência bonita.

## Avaliação
Seu projeto será avaliado de acordo com os seguintes critérios.

1. Sua aplicação preenche os requerimentos básicos?
1. Você documentou a maneira de configurar o ambiente e rodar sua aplicação?
1. Você seguiu as instruções de envio do desafio?
1. Qualidade e cobertura dos testes unitários.

Adicionalmente, tentaremos verificar a sua familiarização com as bibliotecas padrões (standard libs), bem como sua experiência com programação orientada a objetos a partir da estrutura de seu projeto.

### Referência

Este desafio foi baseado neste outro desafio: https://github.com/lschallenges/data-engineering

* Minha implementação

- Instale e configure o ruby 2.6.5.

- Instale o Postgres client e server (ou somente o cliente e utilize o server pelo docker), o conector do Postgres para o seu Sistema Operacional (no Ubuntu 18.04 é a `libpq-dev`). Para instalar o server, recomenda-se a imagem do docker:
$ docker run --name pgs -v /var/run/postgresql:/var/run/postgresql -e
POSTGRES_PASSWORD=mysecretpassword -p 5432:5432  -d postgres
$ docker start pgs

- Faça o download das dependências:

$ gem install bundler; bundle install

- Preencha os valores corretos das variáveis nos arquivos .env do dotenv (já existe um arquivo
  .env.test que além de servir para os testes automatizados, também serve como exemplo para o aquivo
de .env.development ou .env para produção. Repare que as variáveis do .env.test podem precisar ser
alteradas para as configurações da sua máquina).

- Certifique-se de que o usuário definido na variável POSTGRES_USER tem permissões para criação e
  leitura para o banco de dados POSTGRES_USER. Isso será necessário.

- Uma vez configurado o banco e as variáveis de ambiente, execute na linha de comando o seguinte comando para criar a estrutura do banco de dados corretamente.

$ APP_ENV=development ruby -r "./db_manager.rb" -e "DbManager.setup"

- Para testar automatizadamente a aplicação, execute:

$ ruby -r "./upload_app_spec.rb"

- para aplica o linter no código, execute:

$ rubocop -a

- Para habilitar o servidor da aplicação, execute:

$ APP_ENV=development ruby -r "./upload_app.rb"
