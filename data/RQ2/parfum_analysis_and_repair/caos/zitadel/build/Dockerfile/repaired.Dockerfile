#######################
## Final Production Image
#######################
FROM alpine:3 as artifact
COPY zitadel /app/zitadel
RUN adduser -D zitadel && \
    chown zitadel /app/zitadel && \
    chmod +x /app/zitadel

#######################
## Scratch Image
#######################