://blog.docker.com/2016/09/docker-golang/
# https://blog.golang.org/docker

# docker build -t unicode-table .
# docker run -it -p 8080:8080 unicode-table

FROM golang:alpine AS build-env

RUN apk add --update alpine-sdk

ADD . /go-unicode-table

RUN cd /go-unicode-table; make bin

FROM alpine

COPY --from=build-env /go-unicode-table/bin/unicode-table /unicode-table

EXPOSE 8080

CMD /unicode-table -host 0.0.0.0 
