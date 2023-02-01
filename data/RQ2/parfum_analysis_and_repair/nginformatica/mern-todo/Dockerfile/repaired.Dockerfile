FROM node:argon

RUN apt-get update && apt-get install --no-install-recommends mongodb -y && rm -rf /var/lib/apt/lists/*;

RUN service mongodb start

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

ENV PORT 8080

EXPOSE 8080

RUN npm install && npm cache clean --force;
RUN npm run test
RUN npm run build
CMD ["node", "dist/server.js"]
