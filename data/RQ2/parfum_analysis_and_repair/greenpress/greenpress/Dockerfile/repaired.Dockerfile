FROM node:15.14
COPY . .
ENV NODE_ENV=development
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run build

RUN npm run clean
ENV NODE_ENV=production
RUN npm run install:prod-only
