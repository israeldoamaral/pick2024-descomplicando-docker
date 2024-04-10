# DAY-3

# Dockerizando o projeto

> [!NOTE]
Os arquivos dos passos estão na pasta [Dockerizando_projeto](files/Dockerizando_projeto/)


### Clonando o projeto
```
https://github.com/israeldoamaral/giropops-senhas.git
```

### Acessando o diretório da aplicação
```
cd giropops-senhas
```

### Dockerfile
Crie o arquivo Dockerfile para a aplicação

Dockerfile.app
```
FROM python:3.11

WORKDIR /app
COPY requirements.txt .
COPY app.py .
COPY static/ static/
COPY templates/ templates/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
```

### Buildando a imagem da aplicação
```
docker build -t giropops-senhas:1.0 -f Dockerfile.app .
```

### Listando a imagem criado da aplicação
```
docker image ls
```

### Criando uma rede para a comunicação dos containers
```
docker network create giropops
```

### Executando o container do Redis
```
docker container run -d -p 6379:6379 --network giropops --name redis redis
```

### Executando o container da aplicação
> [!TIP] Para a aplicação poder acessar o Redis, vamos passar um valor na variável de ambiente **REDIS_HOST=redis** que é o nome do container do Redis
```
docker run -d --name giropops-senhas --network giropops  -p 5000:5000 --env REDIS_HOST=redis giropops-senhas:1.0
```

### Listando os containers em execução
```
docker container ls
```

### Acessando no navegador
```
localhost:5000
```
![print1](files/Dockerizando_projeto/prints/1.png)

