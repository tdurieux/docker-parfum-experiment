FROM openjdk:16-slim-buster

WORKDIR /app
COPY . .

RUN apt-get update; apt-get install --no-install-recommends -y curl \
    && curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && curl -f -L https://www.npmjs.com/install.sh | sh \
    && npm install -g firebase-tools \
    && firebase setup:emulators:storage && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD [ "firebase", "--project=race", "emulators:start", "--only", "storage" ]
EXPOSE 4000 4400 9199
