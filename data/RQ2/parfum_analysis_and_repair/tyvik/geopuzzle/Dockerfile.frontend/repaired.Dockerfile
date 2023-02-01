FROM node:14.19.0-slim as frontend-builder

WORKDIR /app

RUN apt-get update \
  && apt-get install --no-install-recommends -y git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY package* ./
RUN npm install --only=prod \
  && npm install --only=dev && npm cache clean --force;

ENV NODE_ENV=production

CMD ["node"]
