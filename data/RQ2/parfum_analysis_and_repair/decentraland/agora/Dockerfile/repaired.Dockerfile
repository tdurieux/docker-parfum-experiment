ARG RUN

FROM node:12 as builder

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY tsconfig.json /app/tsconfig.json

RUN apt-get update && apt-get -y --no-install-recommends -qq install python-setuptools python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;

COPY . /app

RUN npm run build

FROM node:12

WORKDIR /app

COPY --from=builder /app /app

ENTRYPOINT [ "./entrypoint.sh" ]
