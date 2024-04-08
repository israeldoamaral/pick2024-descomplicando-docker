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

## Registry<a name="registry-image"></a>

Um registry Docker é um serviço que armazena e distribui imagens Docker. Ele atua como um repositório centralizado onde os desenvolvedores podem compartilhar e acessar imagens Docker. Existem várias implementações de registros Docker, incluindo o Docker Hub (o registro público mantido pela Docker, Inc.), bem como soluções privadas e auto-hospedadas, como o Amazon Elastic Container Registry (ECR), Google Container Registry (GCR), Azure Container Registry (ACR) e Docker Registry (software de código aberto que pode ser executado localmente ou em nuvem).  

As principais funções de um registro Docker incluem:  

1. **Armazenamento** de Imagens: Os registros Docker armazenam imagens Docker, que são artefatos contendo sistemas de arquivos e metadados necessários para executar aplicativos em contêineres.

2. **Distribuição de Imagens**: Os registros Docker distribuem imagens Docker para os hosts que executam o Docker Engine. Isso permite que os desenvolvedores implantem e executem aplicativos em contêineres em qualquer lugar onde o Docker esteja sendo executado.

3. **Controle de Acesso e Segurança**: Os registros Docker geralmente incluem recursos para controlar quem pode acessar e modificar imagens, bem como para garantir a integridade e segurança das imagens armazenadas.

4. **Gerenciamento de Versões**: Os registros Docker geralmente suportam o gerenciamento de versões de imagens, permitindo que os desenvolvedores carreguem e recuperem versões específicas de imagens Docker.

5. **Colaboração**: Os registros Docker facilitam a colaboração entre equipes de desenvolvimento, permitindo que os desenvolvedores compartilhem e colaborem em imagens Docker.

No geral, os registros Docker desempenham um papel fundamental na construção, distribuição e execução de aplicativos em contêineres, fornecendo um mecanismo eficiente para compartilhar e acessar imagens Docker em uma ampla variedade de ambientes de desenvolvimento e produção.

## Criando uma conta do Registry

Para que consiga realizar a criação da sua conta, é necessário acessar no nosso caso vamos criar uma conta no DockerHub acessando a  URL https://hub.docker.com.

Após criar a conta, vamos realizar o login.
```
$ docker login

Username: <Usuário da conta criada>
Password: <SEU TOKEN AQUI>
Login Succeeded
```
Você consegue criar repositórios públicos à vontade, porém na conta free você somente tem direito a um repositório privado. Caso precise de mais do que um repositório privado, é necessário o upgrade da sua conta e o pagamento de uma mensalidade.

## Compartilhando a Imagem

Como exemplo, vamos utilizar a imagem que montamos no multi-stage anteriormente com o dockerfile. Vamos chama-la de  "israeldoamaral/hello".

Quando realizarmos o upload dessa imagem para o Docker Hub, o repositório terá o mesmo nome da imagem, ou seja, "israeldoamaral/hello".

Uma coisa muito importante! A sua imagem deverá ter o seguinte padrão, para que você consiga fazer o upload para o Docker Hub:

**seuusuario/nomedaimagem:versão**

- israeldoamaral - Nome do meu usuário do Docker Hub
- app - Nome da Imagem
- 1.0 - Versão que foi feito o build

```
# primeiro vamos realizar o build da imagem

$ docker build -t israeldoamaral/app:v1.0 .

# Agora vamos utilizar o comando "docker push", responsável por fazer o upload da imagem

$ docker push israeldoamaral/app:1.0
```

