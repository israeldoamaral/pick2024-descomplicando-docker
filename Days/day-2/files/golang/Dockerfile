FROM golang:1.18 as buildando
WORKDIR /app
COPY . ./
RUN go mod init hello
RUN go build -o /app/hello
CMD [ "/app/hello" ]

FROM alpine:3.15.9
COPY --from=buildando /app/hello /app/hello
ENV APP="hello_world"
ARG GIROPOPS="strigus"
ENV GIROPOPS=$GIROPOPS
RUN echo "O giropops é: $GIROPOPS"
CMD [ "/app/hello" ]

#docker build -t goapp:4.0 --build-arg GIROPOPS=catota .