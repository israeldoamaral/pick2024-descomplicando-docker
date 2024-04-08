# DAY-2

# Dockerfile e Imagem de Containers

### Imagens Docker

Uma imagem do Docker é um modelo somente leitura que contém instruções para criar um contêiner.
Ela representa um snapshot ou modelo das bibliotecas e dependências necessárias dentro de um contêiner para que uma aplicação possa ser executada.
Em outras palavras, é como um template que será utilizado pelo contêiner.
As imagens são divididas em camadas somente leitura, formando uma pilha.
Essas camadas contêm todas as bibliotecas, dependências e arquivos necessários para o funcionamento do contêiner.

### Container

Um contêiner é um **ambiente de runtime** que contém todos os componentes necessários para executar o código de uma aplicação.
Ele é criado a partir de uma imagem e inclui o código da aplicação, suas dependências e bibliotecas.
O contêiner é executado **isoladamente**, sem depender das bibliotecas da máquina host.
Essa abordagem permite que os desenvolvedores empacotem software para execução em **qualquer sistema de destino**.
Os contêineres são altamente portáteis e podem ser executados em diferentes máquinas e sistemas operacionais.
Por exemplo, uma aplicação corporativa pode ser dividida em **microsserviços**, cada um executado como um contêiner em várias máquinas e máquinas virtuais (VMs) no datacenter ou na nuvem

### Dockerfile 
<a name="ancora"></a>

```
FROM debian:10
RUN apt-get update && apt-get install -y apache2 curl && apt-get clean
ENV APACHE_LOCK_DIR="/var/lock"
ENV APACHE_PID_FILE="/var/run/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"
LABEL description="Webserver"
VOLUME [ "/var/www/html" ]
EXPOSE 80
ENTRYPOINT [ "/usr/sbin/apachectl" ]
CMD [ "-D", "FOREGROUND" ]
```

### Estrutura e instruções do Dockerfile 


1. FROM: A instrução FROM define a imagem base para a construção da nova imagem. Aqui, estamos usando a imagem oficial do Debian 10 como ponto de partida.
2. RUN: A instrução RUN executa comandos no ambiente de construção da imagem.

   Neste caso, estamos realizando as seguintes ações:  
   apt-get update: Atualiza o cache dos pacotes disponíveis.  
   apt-get install -y apache2 curl: Instala os pacotes Apache2 e curl.  
   apt-get clean: Remove arquivos temporários gerados durante a instalação.  
3. ENV: A instrução ENV define variáveis de ambiente dentro do contêiner.

   Neste caso estamos definindo as variáveis:  
   - ENV APACHE_LOCK_DIR="/var/lock": Essa variável é usada pelo Apache para especificar o diretório de bloqueio.  
   - ENV APACHE_PID_FILE="/var/run/apache2.pid": Essa variável especifica o local do arquivo PID (identificador de processo) do Apache.  
   - ENV APACHE_RUN_USER="www-data": Essas linhas definem as variáveis de ambiente para o usuário que executarão o Apache.  
   - ENV APACHE_RUN_GROUP="www-data": Essas linhas definem as variáveis de ambiente para o grupo que executará o Apache.  
   - ENV APACHE_LOG_DIR="/var/log/apache2": Essa variável especifica o diretório onde os logs do Apache serão armazenados.  

4. LABEL: A instrução LABEL adiciona etiquetas à imagem.
5. VOLUME: A instrução cria um volume no contêiner. Isso permite que dados sejam persistidos entre contêineres e o host.
6. EXPOSE: Informa ao Docker que o contêiner escutará na porta 80.
- ENTRYPOINT: A instrução define o ponto de entrada para o contêiner.
- CMD: Define o comando padrão a ser executado quando o contêiner for iniciado.

### Buildando a imagem

O comando docker build é usado para construir uma imagem Docker a partir de um Dockerfile e um contexto.

```
$ docker build -t apache_server:v1.0 .
```

### Listando a imagem criada
O comando docker image ls lista todas as imagens Docker disponíveis no seu sistema. Ele exibe informações sobre as imagens, incluindo o nome do repositório, as tags associadas e o tamanho. 

```
$ docker image ls
```

### Iniciando o container da imagem criada

O comando "docker run" é usado para iniciar um contêiner com base em uma imagem existente.

```
docker run -p 8080:80 -d --name apache apache_server:v1.0
```

