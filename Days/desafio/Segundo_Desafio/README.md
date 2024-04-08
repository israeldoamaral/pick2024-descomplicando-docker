## Segundo Desafio Prático


Essa desafio é divido em duas partes, a primeira parte do desafio será apénas executar localmente a aplicação.  
A segunda parte iremos criar as imagens docker e executa-lo.

Primeira parte:

    Somente seguir os passos para saber como deixar a App funcionando, sem ser no container.
    Anotar todos os detalhes importantes para transformar essa app em uma imagem de container.


## Instruções

1. Clonar a repo da LINUXtips:

    ```
    git clone https://github.com/badtuxx/giropops-senhas.git
    ```

2. Entrar no diretório
    ```
    cd giropops-senhas/
    ```

3. Realizando o update do apt
    ```
    apt-get update
    ```

4. Instalando o PIP
    ```
    apt-get install pip
    ```

5. Instalando todas as dependencias da nossa app
    ```
    pip install --no-cache-dir -r requirements.txt
    ```

6. Instalando o Redis, que é usado pela nossa app
    ```
    apt-get install redis
    ```

7. Iniciando o Redis
    ```
    systemctl start redis
    ```

8. Verificando o status do Redis 
    ```
    systemctl status redis
    ```

9. Criando a variavel de ambiente para que a nossa App saiba onde está o Redis
    ```
    export REDIS_HOST=localhost
    ```

10. Iniciando a nossa App
    ```
    flask run --host=0.0.0.0
    ```



## Segunda parte

Agora que já sabe como colocar a App para rodar, precisamos coloca-la em uma imagem de container! E para isso, precisamos criar um DockerFile e lá, adicionar todos os detalhes necessários!

1. Criar um conta no Docker Hub, caso ainda não possua uma.  
2. Criar uma conta no Github, caso ainda não possua uma.  
3. Criar um Dockerfile para criar uma imagem de container para a nossa App
4. Build a imagem. 
> [!TIP]  
O nome da imagem deve ser SEU_USUARIO_NO_DOCKER_HUB/linuxtips-giropops-senhas:1.0

5. Fazer o push da imagem para o Docker Hub, essa imagem deve ser pública.  
6. Criar um repo no Github chamado LINUXtips-Giropops-Senhas, esse repo deve ser público.
7. Fazer o push do cógido da App e o Dockerfile.  
8. Criar um container utilizando a imagem criada. O nome do container deve ser giropops-senhas.   
9. O Redis precisa ser um container.

Dica: Preste atenção no uso de variável de ambiente, precisamos ter a variável REDIS_HOST no container. Use sua criatividade!


### Passos

1. Criar o arquivos Dockerfile para a aplicação.

    Dockerfile.app  

    ```
    FROM python:3.13.0a4-alpine3.19

    LABEL description="Desafio day2" \
      stack="Python" \
      version="3.13.0a4-alpine3.19"

    RUN mkdir -p /usr/src/app
    WORKDIR /usr/src/app

    COPY requirements.txt /usr/src/app/
    RUN pip install --no-cache-dir -r requirements.txt && pip install werkzeug===2.2.2

    COPY app.py .
    COPY templates/ templates/
    COPY static/ static/

    EXPOSE 5000

    ENV REDIS_HOST="redis-server"

    ENTRYPOINT ["flask", "run", "--host=0.0.0.0"]
    ```

2. Criando a imagem da aplicação
    ```
    docker build -t israeldoamaral/linuxtips-giropops-senhas:1.0 -f Dockerfile.app .
    ```
3. Push da imagem da aplicação para o DockerHub
    ```
    docker push israeldoamaral/linuxtips-giropops-senhas:1.0
    ```
4. Criar o arquivos Dockerfile para a Redis.  
    
    Dockerfile.app

    ```
    FROM redis:7.2.4

    LABEL description="Desafio Day2" \
      stack="Redis" \
      version="7.2.4"

    EXPOSE 6379

    ENTRYPOINT [ "redis-server" ]
    ```

5. Criando a imagem do Redis
    ```
    docker build -t israeldoamaral/redis-server -f Dockerfile.redis .
    ```

6. Push da imagem do Redis para o DockerHub
    ```
    docker push israeldoamaral/redis-server
    ```

7. Com o repositório do Github criado com o nome "**LINUXtips-Giropops-Senhas**", faça o push dos cógidos da aplicação e do arquivos Dockerfile.

8. Criando os containers da aplicação e Redis apartir do repositório.
    ```
    # vamos criar uma network para a comunicação entre o app e o Redis.  
    $ docker network create giropops 
    
    # vamos executar o container da aplicação  
    $ docker run -it -p 5000:5000 --network giropops --name giropops-senhas israeldoamaral/linuxtips-giropops-senhas:1.0

    # vamos executar o container do Redis
    $ docker run -d --name redis-server --network giropops israeldoamaral/redis-server
    ```
