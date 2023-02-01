FROM alpine:latest

# Install build-essentials
RUN apk add --no-cache git git-lfs openssh-client

CMD ["sh"]
