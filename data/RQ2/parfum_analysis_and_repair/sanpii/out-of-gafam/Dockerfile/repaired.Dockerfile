FROM rust:latest

ENV APP_ENVIRONMENT=prod
ENV BOWER_FLAGS=--allow-root

COPY . .
RUN apt update \
    && apt install --no-install-recommends -y npm \
    && npm install -g bower && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN make
CMD ["target/release/oog"]
