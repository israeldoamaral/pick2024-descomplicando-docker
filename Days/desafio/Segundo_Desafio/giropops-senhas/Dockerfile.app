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

# docker network create app_network
# docker build -t israeldoamaral/linuxtips-giropops-senhas:1.0 -f Dockerfile.app .
# docker run -it -p 5000:5000 --network app_network --name app israeldoamaral/linuxtips-giropops-senhas:1.0