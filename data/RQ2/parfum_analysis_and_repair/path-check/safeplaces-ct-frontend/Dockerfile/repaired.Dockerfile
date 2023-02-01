FROM node:13.12.0-alpine As builder
LABEL proejct="Safe-Paths React"
LABEL maintainer="sherif@extremesolution.com"
# setting working dir
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
# install app dependencies
ADD . $WORKDIR
RUN yarn install && yarn cache clean;
RUN yarn run build && yarn cache clean;

FROM node:13.12.0-alpine
# setting working dir
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
COPY --from=builder /app .
RUN touch .env
RUN yarn global add serve && yarn cache clean;
CMD [ "serve" , "-s", "build", "-l" , "3000"]
