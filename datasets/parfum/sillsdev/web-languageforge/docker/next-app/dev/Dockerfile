FROM node:alpine

WORKDIR /app

COPY jsconfig.json package-lock.json package.json postcss.config.cjs svelte.config.js tailwind.config.cjs /app
COPY src /app/src
COPY static /app/static

RUN npm install

EXPOSE 3000
