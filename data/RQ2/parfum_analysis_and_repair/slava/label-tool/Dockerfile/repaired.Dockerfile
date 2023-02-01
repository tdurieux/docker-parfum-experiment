FROM node:10.15.2

RUN apt-get -y update && apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


WORKDIR /db
WORKDIR /uploads
WORKDIR /app
COPY . .
RUN yarn install && yarn cache clean;
RUN cd client && yarn install && yarn cache clean;
RUN cd server && yarn install && yarn cache clean;
RUN cd client && yarn build

ENV DATABASE_FILE_PATH=/db/db.sqlite
ENV UPLOADS_PATH=/uploads

ENV PORT=3000
ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server/src/index.js"]
