# DAY-2

# Imagem de Containers

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

### Dockerfile<a name="ancoradockerfile"></a>
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

### Estrutura e instruções do Dockerfile<a name="estrutura-dockerfile"></a>


- ADD -- Copia novos arquivos, diretórios, arquivos TAR ou arquivos remotos e os adiciona ao filesystem do container.

- CMD -- Executa um comando. Diferentemente do RUN, que executa o comando no momento em que está "buildando" a imagem, o CMD irá fazê-lo somente quando o container é iniciado.

- LABEL -- Adiciona metadados à imagem, como versão, descrição e fabricante.

- COPY -- Copia novos arquivos e diretórios e os adiciona ao filesystem do container.

- ENTRYPOINT -- Permite que você configure um container para rodar um executável. Quando esse executável for finalizado, o container também será.

- ENV -- Informa variáveis de ambiente ao container.

- EXPOSE -- Informa qual porta o container estará ouvindo.

- FROM -- Indica qual imagem será utilizada como base. Ela precisa ser a primeira linha do dockerfile.

- MAINTAINER -- Autor da imagem.

- RUN -- Executa qualquer comando em uma nova camada no topo da imagem e "commita" as alterações. Essas alterações você poderá utilizar nas próximas instruções de seu dockerfile.

- USER -- Determina qual usuário será utilizado na imagem. Por default é o root.

- VOLUME -- Permite a criação de um ponto de montagem no container.

- WORKDIR -- Responsável por mudar do diretório "/" (raiz) para o especificado nele.

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

## Multi-stage<a name="multistage-image"></a>

O recurso de multi-stage em Dockerfile é uma técnica que permite criar imagens Docker de forma mais eficiente, especialmente útil quando você precisa compilar aplicativos ou executar tarefas de construção que exigem um conjunto de ferramentas específico que não é necessário na imagem final. Isso ajuda a manter o tamanho da imagem final o mais compacto possível.

Em essência, o multi-stage build permite definir várias etapas (ou "estágios") no Dockerfile, onde cada etapa pode usar uma imagem base diferente e realizar operações específicas. O resultado final é que apenas o conteúdo da última etapa é incluído na imagem resultante, o que reduz o tamanho final da imagem.  

Aqui está um exemplo básico de como um Dockerfile usando multi-stage pode ser estruturado:

```
FROM golang:1.18 as build
WORKDIR /app
COPY . ./
RUN go mod init hello
RUN go build -o /app/hello

FROM alpine:3.15.9
COPY --from=buildando /app/hello /app/hello
CMD ["/app/hello"]
```
Neste exemplo:  

1. A primeira etapa (**FROM golang:1.18 as build**) usa uma imagem do Golang que contém todas as ferramentas necessárias para compilar o código fonte.
2. Os arquivos do código fonte são copiados para o diretório de trabalho (**WORKDIR /app**) dentro do contêiner.
3. O comando de compilação é executado (**RUN go build -o /app/hello**), produzindo os artefatos compilados ou construídos.
4. Em seguida, começa a segunda etapa (**FROM alpine:3.15.9**), onde uma imagem mais leve é utilizada como base. Esta imagem pode ser uma imagem de produção ou uma imagem mais compacta, sem as ferramentas de compilação.
5. Os artefatos gerados na primeira etapa são copiados para a segunda etapa usando a instrução (**COPY --from=buildando /app/hello /app/hello**).
6. Finalmente, a instrução **CMD** ou **ENTRYPOINT** é usada para definir o comando padrão que será executado quando o contêiner for iniciado.  

## Registry