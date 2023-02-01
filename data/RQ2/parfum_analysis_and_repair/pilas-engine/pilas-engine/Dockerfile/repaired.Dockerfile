FROM node:12.13.0

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ["package.json", "yarn.lock", "Makefile", "./"]
RUN make iniciar
COPY . .
