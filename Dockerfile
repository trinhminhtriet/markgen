FROM golang:1.24-bullseye AS builder

WORKDIR /build

COPY . .

# Build
RUN go mod download && go mod tidy
RUN go build

# final stage
FROM debian:bullseye-slim
RUN apt-get update && \
  apt-get install -y --no-install-recommends curl ca-certificates && \
  rm -rf /var/lib/apt/lists/*

ARG APPLICATION="markgen"
ARG DESCRIPTION="📜 Generate personalized markdown files with templates, GitHub, RSS, and API integrations using Go."
ARG PACKAGE="trinhminhtriet/markgen"

LABEL org.opencontainers.image.ref.name="${PACKAGE}" \
  org.opencontainers.image.authors="Triet Trinh <contact@trinhminhtriet.com>" \
  org.opencontainers.image.documentation="https://github.com/${PACKAGE}/README.md" \
  org.opencontainers.image.description="${DESCRIPTION}" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/${PACKAGE}"

COPY --from=builder /build/markgen /bin/
WORKDIR /workdir
ENTRYPOINT ["/bin/markgen"]
