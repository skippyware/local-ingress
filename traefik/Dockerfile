ARG ALPINE_VERSION=3.21
ARG GOLANG_VERSION=1.23-alpine

FROM --platform=${BUILDPLATFORM} golang:${GOLANG_VERSION} AS builder

ARG TARGETARCH

WORKDIR /go/src

RUN apk --no-cache add ca-certificates curl make \
    && curl -s -f -L -o /traefik-v3.3.3.src.tar.gz https://github.com/traefik/traefik/releases/download/v3.3.3/traefik-v3.3.3.src.tar.gz \
    && tar xzvf /traefik-v3.3.3.src.tar.gz -C /go/src --strip-components 1 \
    && go get github.com/go-acme/lego/v4@v4.22.2 \
    && go mod tidy \
    && make binary-linux-${TARGETARCH}

FROM alpine:${ALPINE_VERSION}
ARG TARGETARCH
COPY --from=builder /go/src/dist/linux/${TARGETARCH}/traefik /usr/local/bin/traefik
RUN apk --no-cache add ca-certificates tzdata \
    && chmod +x /usr/local/bin/traefik
COPY traefik/entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Traefik Labs" \
    org.opencontainers.image.url="https://traefik.io" \
    org.opencontainers.image.source="https://github.com/traefik/traefik" \
    org.opencontainers.image.title="Traefik" \
    org.opencontainers.image.description="A modern reverse-proxy" \
    org.opencontainers.image.version="v3.3.3" \
    org.opencontainers.image.documentation="https://docs.traefik.io"
