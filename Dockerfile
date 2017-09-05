FROM i386/ubuntu

# RUN apk update && apk add openssl wget ca-certificates bash musl-dev gcc g++ make
RUN apt-get update && apt-get install wget gcc g++ make


# Build boostrap
ADD bootstrap.bash /root/go/
RUN cd /root/go/ && CGO_ENABLED=0 GOOS=linux GOARCH=386 GO386=387 ./bootstrap.bash

# Build Go
ADD buildgo.bash /root/go/
RUN cd /root/go/ && GOOS=linux GOARCH=386 GO386=387 ./buildgo.bash

