FROM squidfunk/mkdocs-material as builder
COPY src /docs
RUN mkdocs build

FROM caddy as server
COPY --from=builder /docs/site /usr/share/caddy