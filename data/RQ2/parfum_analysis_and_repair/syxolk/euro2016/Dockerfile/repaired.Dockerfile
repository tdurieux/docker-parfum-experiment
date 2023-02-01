FROM node:16.3.0-slim
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package.json /app
COPY package-lock.json /app
RUN npm install && npm cache clean --force;

COPY . /app

ENV NODE_ENV production
ENV TRUST_PROXY 1
CMD ["./entrypoint.sh"]