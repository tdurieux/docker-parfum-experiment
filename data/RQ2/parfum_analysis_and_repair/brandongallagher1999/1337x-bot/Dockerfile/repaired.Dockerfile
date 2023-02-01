#Version Locking Node
FROM node:17.4

COPY . .

EXPOSE 80
EXPOSE 443

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn global add typescript && yarn cache clean;
RUN yarn global add ts-node && yarn cache clean;

ENTRYPOINT ["yarn"]