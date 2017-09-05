FROM alpine

RUN apk update && apk add openssl wget ca-certificates bash bzip2 musl-dev gcc g++ make


# Build boostrap
ADD bootstrap.bash /
RUN CGO_ENABLED=0 GOOS=linux GOARCH=386 GO386=387 ./bootstrap.bash

# Build Go
ADD buildgo.bash /
RUN  GOOS=linux GOARCH=386 GO386=387 ./buildgo.bash

