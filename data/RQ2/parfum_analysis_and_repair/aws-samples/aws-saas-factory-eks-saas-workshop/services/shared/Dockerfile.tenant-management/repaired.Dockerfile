FROM public.ecr.aws/bitnami/node:16.13.1 AS build
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
RUN yarn build tenant-management && yarn cache clean;

FROM public.ecr.aws/bitnami/node:16.13.1
WORKDIR /app
COPY --from=build /app ./
EXPOSE 3001
CMD ["npm", "run", "start:tm"]
