FROM node:16.2.0
RUN apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*;

COPY . /api
WORKDIR /api

RUN npm install && npm cache clean --force;
RUN npm run build

CMD echo "Hello, world"

