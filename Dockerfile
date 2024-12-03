
FROM --platform=$BUILDPLATFORM golang:1.23-bookworm AS builder
ARG TARGETOS TARGETARCH

WORKDIR /app

COPY go.* ./
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go mod download

COPY . ./

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -v -o ntfy-bridge

FROM debian:bookworm-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/ntfy-bridge /app/ntfy-bridge

CMD ["/app/ntfy-bridge"]
