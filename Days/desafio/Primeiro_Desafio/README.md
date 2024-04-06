# ## Primeiro Desafio Prático


Criar uma imagem para rodar um Nginx. A imagem base precisa ser o Alpine Linux, e claro, precisamos ter o Nginx rodando perfeitamente.

Algumas informações importantes:

    O nome do container deve ser: giropops-web.
    A porta do container e do host deverão ser a porta 80.
    Deve conter um HEALTHCHECK.


## Dockerfile

```
FROM alpine:3.19.1
RUN apk update && apk add nginx curl && rm -rf /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html

EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
HEALTHCHECK --timeout=2s CMD curl -f localhost || exit 1
```

### Buildando a imagem

```
docker build -t giropops-web .
```

### Rodando o container
```
docker run -p 80:80 --name giropops-web giropops-web
```
