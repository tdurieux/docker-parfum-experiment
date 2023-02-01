FROM node:16

WORKDIR /admin

ENV NODE_ENV="production"
ENV TZ="UTC"

COPY package.json ./
COPY yarn.lock ./

RUN yarn install --frozen-lockfile --production && yarn cache clean;
COPY . .

RUN npm i -g typescript && npm cache clean --force;
RUN yarn build
RUN npx prisma generate
RUN rm -rf src

ENV ADMIN_JS_SKIP_BUNDLE="true"

EXPOSE 3000
CMD yarn start
