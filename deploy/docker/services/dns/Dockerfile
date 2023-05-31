FROM docker.io/library/golang:1.20.4-alpine3.18 AS stage0

WORKDIR /usr/src/app
COPY --link ./src/ ./
RUN go mod download && go mod verify

RUN go build -v -o /coredns --ldflags '-s -w -extldflags "-static"' ./main.go

FROM alpine:3.18

COPY --from=stage0 /coredns /coredns
ENTRYPOINT [ "/coredns", "-conf", "/Corefile" ]
