FROM alpine

RUN apk update && apk add openssl wget ca-certificates bash bzip2 musl-dev gcc g++ make


# Build boostrap
ADD bootstrap.bash /root/go/
RUN cd /root/go/ && GOOS=linux GOARCH=386 GO386=387 ./bootstrap.bash

# Build Go
ADD buildgo.bash /root/go/
RUN cd /root/go/ && GOOS=linux GOARCH=386 GO386=387 ./buildgo.bash

