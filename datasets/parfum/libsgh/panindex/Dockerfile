FROM alpine:edge as builder
LABEL stage=go-builder
ARG VERSION
ENV GITHUB_REF=$VERSION
WORKDIR /app/
COPY ./ ./
RUN apk add --no-cache bash git curl go gcc musl-dev; \
    curl -s -O 'https://raw.githubusercontent.com/libsgh/PanIndex-build-action/main/build.sh'; \
    bash build.sh docker

FROM alpine:edge
MAINTAINER libsgh
WORKDIR /app
COPY --from=builder /app/bin/PanIndex ./
CMD ["/app/PanIndex"]
