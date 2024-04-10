FROM python:3.11

WORKDIR /app
COPY requirements.txt .
COPY app.py .
COPY static/ static/
COPY templates/ templates/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]

# docker network create app_network
# docker run -it -p 5000:5000 --network app_network --name app israeldoamaral/linuxtips-giropops-senhas:1.0