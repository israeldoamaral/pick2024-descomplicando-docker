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

vim Dockerfile.app
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
docker build -t israeldoamaral/giropops-senhas:1.0 -f Dockerfile.app .
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


## Tamanho e número de camadas da imagem<a name="tamanhoecamadas"></a>

As camadas de imagem Docker são uma parte essencial da arquitetura Docker e são fundamentais para sua eficiência e funcionalidade. Elas representam os diferentes estados de uma imagem Docker conforme são construídas e modificadas. Aqui está uma descrição geral das camadas de imagem Docker:  

1. **Camada Base (Base Layer):** Esta é a primeira camada de uma imagem Docker. Ela contém o sistema operacional base ou uma imagem de base que serve como ponto de partida para a construção de outras camadas. Geralmente, as imagens de base são imagens Linux como Alpine, Ubuntu, CentOS, etc.  

2. **Camadas de Pacotes (Package Layers):** Essas camadas contêm os pacotes e dependências adicionados à imagem. Cada instrução no Dockerfile (como RUN, COPY, ADD) cria uma nova camada na imagem. Por exemplo, se você instalar pacotes usando o RUN apt-get install, cada instalação de pacote será uma camada separada na imagem. Isso permite a reutilização eficiente de camadas comuns entre imagens.  

3. **Camada de Sistema de Arquivos de Leitura (Read-only File System Layer):** Após a construção das camadas de pacotes, o sistema de arquivos da imagem é marcado como somente leitura. Isso garante que a imagem seja imutável e não seja modificada acidentalmente.  

4. **Camada de Escrita (Writable Layer):** Esta camada é adicionada quando um contêiner é instanciado a partir da imagem. Ela permite que o contêiner escreva e faça alterações no sistema de arquivos da imagem. Qualquer alteração feita no contêiner, como a criação de novos arquivos ou a modificação de arquivos existentes, é armazenada nessa camada.  

Essa arquitetura em camadas é fundamental para a eficiência do Docker, pois permite a reutilização de camadas comuns entre imagens, reduzindo a quantidade de dados que precisam ser transferidos durante o processo de construção e implantação de contêineres. Isso resulta em tempos de construção mais rápidos, menor uso de armazenamento e melhor desempenho geral.

### Verificando as camadas da imagem  

Vamos analisar as camadas da imagem gerada  

```
$ docker history israeldoamaral/giropops-senhas:1.0  


IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
2bd548ceb790   5 days ago    CMD ["flask" "run" "--host=0.0.0.0"]            0B        buildkit.dockerfile.v0
<missing>      5 days ago    EXPOSE map[5000/tcp:{}]                         0B        buildkit.dockerfile.v0
<missing>      5 days ago    RUN /bin/sh -c pip install --no-cache-dir -r…   18.2MB    buildkit.dockerfile.v0
<missing>      5 days ago    COPY templates/ templates/ # buildkit           5.78kB    buildkit.dockerfile.v0
<missing>      5 days ago    COPY static/ static/ # buildkit                 112kB     buildkit.dockerfile.v0
<missing>      5 days ago    COPY app.py . # buildkit                        2.52kB    buildkit.dockerfile.v0
<missing>      5 days ago    COPY requirements.txt . # buildkit              52B       buildkit.dockerfile.v0
<missing>      5 days ago    WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      12 days ago   CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      12 days ago   RUN /bin/sh -c set -eux;   wget -O get-pip.p…   11.2MB    buildkit.dockerfile.v0
<missing>      12 days ago   ENV PYTHON_GET_PIP_SHA256=dfe9fd5c28dc98b5ac…   0B        buildkit.dockerfile.v0
<missing>      12 days ago   ENV PYTHON_GET_PIP_URL=https://github.com/py…   0B        buildkit.dockerfile.v0
<missing>      12 days ago   ENV PYTHON_SETUPTOOLS_VERSION=65.5.1            0B        buildkit.dockerfile.v0
<missing>      12 days ago   ENV PYTHON_PIP_VERSION=24.0                     0B        buildkit.dockerfile.v0
<missing>      12 days ago   RUN /bin/sh -c set -eux;  for src in idle3 p…   32B       buildkit.dockerfile.v0
<missing>      12 days ago   RUN /bin/sh -c set -eux;   wget -O python.ta…   50.2MB    buildkit.dockerfile.v0
<missing>      12 days ago   ENV PYTHON_VERSION=3.11.9                       0B        buildkit.dockerfile.v0
<missing>      12 days ago   ENV GPG_KEY=A035C8C19219BA821ECEA86B64E628F8…   0B        buildkit.dockerfile.v0
<missing>      12 days ago   RUN /bin/sh -c set -eux;  apt-get update;  a…   18.6MB    buildkit.dockerfile.v0
<missing>      12 days ago   ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      12 days ago   ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      6 days ago    /bin/sh -c set -ex;  apt-get update;  apt-ge…   587MB     
<missing>      6 days ago    /bin/sh -c set -eux;  apt-get update;  apt-g…   177MB     
<missing>      6 days ago    /bin/sh -c set -eux;  apt-get update;  apt-g…   48.4MB    
<missing>      6 days ago    /bin/sh -c #(nop)  CMD ["bash"]                 0B        
<missing>      6 days ago    /bin/sh -c #(nop) ADD file:ca6d1f0f80dd6c91b…   117MB
```  

> [!NOTE]
Perceba que além das camadas adicionadas por nós no nosso  Dockfile, exitem as camadas da imagem base que no caso usamos a **python:3.11**  


Embora as camadas de imagem Docker ofereçam muitos benefícios em termos de eficiência e reutilização, elas também podem apresentar alguns desafios e problemas potenciais:  

1. **Aumento do tamanho da imagem:** Cada camada adiciona um overhead ao tamanho total da imagem. Se uma imagem tiver muitas camadas, especialmente camadas grandes, ela pode se tornar significativamente maior do que o necessário. Isso pode aumentar os tempos de download e os requisitos de armazenamento.  

2. **Dificuldades de gerenciamento:** Com muitas camadas, pode ser difícil entender e gerenciar as dependências e os pacotes incluídos na imagem. Isso pode tornar a manutenção e a depuração mais complicadas, especialmente se as camadas não forem devidamente documentadas.  

3. **Aumento do tempo de construção:** Quanto mais camadas uma imagem tiver, mais tempo será necessário para construir e reconstruir a imagem. Isso ocorre porque o Docker precisa criar e armazenar cada camada separadamente, o que pode levar a um tempo de construção mais longo, especialmente em sistemas com recursos limitados.  

4. **Ineficiência na camada de escrita:** As alterações feitas em contêineres baseados em imagens com muitas camadas podem levar a uma fragmentação do sistema de arquivos e um aumento no consumo de espaço em disco. Isso ocorre porque o Docker cria uma nova camada de escrita para cada alteração, o que pode resultar em várias cópias de arquivos sendo armazenadas no disco.  

5. **Segurança:** Imagens com muitas camadas podem aumentar a superfície de ataque, pois cada camada representa um ponto de entrada potencial para exploração. Se uma camada contiver vulnerabilidades de segurança, elas podem ser propagadas para outras imagens construídas sobre essa base.  

Embora esses problemas possam surgir em imagens com muitas camadas, muitos deles podem ser mitigados com boas práticas de desenvolvimento e gerenciamento de imagens Docker, como a redução do número de camadas, a seleção cuidadosa das dependências e a otimização do Dockerfile.  

### Verificando o tamanho da imagem

```
$ docker image ls  

REPOSITORY                       TAG       IMAGE ID       CREATED         SIZE
israeldoamaral/giropops-senhas   1.0       2bd548ceb790   5 days ago      1.03GB
```

### Diminuindo tamanho da imagem

Para diminuir a imagem da aplicação vamos utilizar um imagem **slim** python:3.11-slim

```
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
COPY app.py .
COPY static/ static/
COPY templates/ templates/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
```  

Vamos buildar a imagem e versionar para 2.0
```
docker build -t israeldoamaral/giropops-senhas:2.0 -f Dockerfile.app .
```  

verificando a diferença de tamanho das duas imagens

```
$ docker image ls                                                       
REPOSITORY                       TAG       IMAGE ID       CREATED         SIZE
israeldoamaral/giropops-senhas   2.0       8c53ce8bca1a   2 minutes ago   149MB
israeldoamaral/giropops-senhas   1.0       2bd548ceb790   5 days ago      1.03GB
```


## Distroless