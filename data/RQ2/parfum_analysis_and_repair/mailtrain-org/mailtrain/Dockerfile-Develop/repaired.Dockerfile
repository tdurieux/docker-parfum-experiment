# Final Develop Image
FROM node:10-alpine

WORKDIR /app/

# Install system dependencies
RUN set -ex; \
    apk add --update --no-cache \
    make gcc g++ git python pwgen netcat-openbsd bash imagemagick

EXPOSE 3000 3003 3004

# Keep container running, so you can access it