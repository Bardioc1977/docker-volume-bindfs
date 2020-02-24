FROM golang:1.13-stretch as builder
COPY . /go/src/github.com/Bardioc1977/docker-volume-bindfs
WORKDIR /go/src/github.com/Bardioc1977/docker-volume-bindfs
RUN set -ex && go install --ldflags '-extldflags "-static"'
CMD ["/go/bin/docker-volume-bindfs"]

FROM debian
RUN apt-get update && apt-get install bindfs -y
RUN mkdir -p /dev/fuse /run/docker/plugins /var/lib/docker-volumes/bindfs /host
COPY --from=builder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
