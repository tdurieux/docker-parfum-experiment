# -------- Stage 1 - Develop Container
FROM node:12 AS develop
VOLUME ["/usr/src/app"]
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        chromium && rm -rf /var/lib/apt/lists/*;

# -------- Stage 2 - Build Container
FROM develop AS builder
COPY ./ /build/
WORKDIR /build
RUN npm install && npm cache clean --force;
RUN npm run build
RUN npm test

WORKDIR /build/demopage
RUN npm install && npm cache clean --force;
RUN npm run build


# -------- Stage 3 - Demopage serve container
FROM httpd:2.4
COPY --from=builder /build/demopage/dist/ /usr/local/apache2/htdocs/