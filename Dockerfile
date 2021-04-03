# ARG BASE_IMAGE=scratch
ARG BASE_IMAGE=alpine:3.13.1

# ---------------------  dev (build) image --------------------- #

FROM golang:1.14-alpine as builder

RUN apk add git
RUN apk add make

RUN mkdir -p /opt/gobetween
WORKDIR /opt/gobetween

RUN mkdir ./src
COPY ./gobetween/src/go.mod ./src/go.mod
COPY ./gobetween/src/go.sum ./src/go.sum

COPY ./gobetween/go.mod .
COPY ./gobetween/go.sum .

RUN go mod download

COPY ./gobetween/. .

RUN make build-static

# --------------------- final image --------------------- #

FROM $BASE_IMAGE

WORKDIR /

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /opt/gobetween/bin/gobetween  .

RUN apk add --no-cache curl

CMD ["/gobetween", "-c", "/etc/gobetween/conf/gobetween.toml"]

LABEL org.label-schema.vendor="gobetween" \
      org.label-schema.url="http://gobetween.io" \
      org.label-schema.name="gobetween" \
      org.label-schema.description="Modern & minimalistic load balancer for the Сloud era"
