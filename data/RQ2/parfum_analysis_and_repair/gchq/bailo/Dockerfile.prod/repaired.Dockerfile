# Install dependencies only when needed
FROM node:16-alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM node:16-alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run build && \
    mkdir /s2i && \
    wget -O s2i.tar.gz https://github.com/openshift/source-to-image/releases/download/v1.3.1/source-to-image-v1.3.1-a5a77147-linux-amd64.tar.gz && \
    tar -xvf s2i.tar.gz -C /s2i && \
    rm -rf s2i.tar.gz

# Production image, copy all the files and run next
FROM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ARG user_id=1001

RUN apk update \
    && apk add --no-cache ca-certificates img docker \
    && rm -rf /var/cache/apk/* \
    && chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap \
    && adduser -D -u $user_id nextjs \
    && mkdir -p /run/user/$user_id \
    && chown -R nextjs /run/user/$user_id /home/nextjs \
    && addgroup -S certs \
    && addgroup nextjs certs \
    && chgrp certs /etc/ssl/certs \
    && chmod 775 /etc/ssl/certs \
    && chgrp certs /usr/local/share/ca-certificates \
    && chmod 775 /usr/local/share/ca-certificates \
    && echo nextjs:100000:65536 | tee /etc/subuid | tee /etc/subgid


# You only need to copy next.config.js if you are NOT using the default configuration
# COPY --from=builder /app/next.config.js ./
COPY --from=builder --chown=nextjs:nextjs /app/dist ./dist
COPY --from=builder --chown=nextjs:nextjs /app/lib/p-mongo-queue ./dist/lib/p-mongo-queue
COPY --from=builder --chown=nextjs:nextjs /app/config ./config
COPY --from=builder --chown=nextjs:nextjs /app/public ./public

COPY --from=builder --chown=nextjs:nextjs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder --chown=nextjs:nextjs /s2i /s2i
COPY ./scripts/run_app_prod.sh ./scripts/run_app_prod.sh

USER nextjs
ENV USER nextjs
ENV HOME /home/nextjs
ENV XDG_RUNTIME_DIR=/run/user/$user_id

EXPOSE 3000

ENV PORT 3000
ENV NEXT_TELEMETRY_DISABLED 1

CMD ./scripts/run_app_prod.sh
