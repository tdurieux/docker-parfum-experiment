FROM node:9

RUN apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*;