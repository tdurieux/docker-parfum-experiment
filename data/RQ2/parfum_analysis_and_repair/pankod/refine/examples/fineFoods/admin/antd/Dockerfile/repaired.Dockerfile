FROM node:16-alpine

WORKDIR /opt/app

ENV NODE_ENV development

COPY package*.json ./
COPY .npmrc ./

RUN npm install && npm cache clean --force;

COPY . /opt/app

RUN npm run bootstrap -- --scope fine-foods -- --force
RUN npm run build -- --scope fine-foods

FROM node:16-alpine

COPY --from=0 /opt/app/examples/fineFoods/admin/antd/build /opt/app
WORKDIR /opt/app/

ENV NODE_ENV=production

RUN npm install -g serve && npm cache clean --force;

CMD serve -l 5000
