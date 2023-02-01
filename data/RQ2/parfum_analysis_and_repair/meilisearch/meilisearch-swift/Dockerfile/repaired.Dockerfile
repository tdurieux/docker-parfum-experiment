# Run
FROM    maxdesiatov/swift-alpine

RUN apk add -q --no-cache libgcc tini curl && \
        curl -f -L https://install.meilisearch.com | sh && \
        chmod +x meilisearch

COPY . .

ENTRYPOINT ["tini", "--"]
CMD ./meilisearch
