FROM node:11-alpine
EXPOSE 3000 6379 50051 8080

RUN npm install -g npm && npm cache clean --force;

RUN npm install -g typescript && npm cache clean --force;
RUN npm install -g ts-node && npm cache clean --force;
RUN npm install -g ts-node-dev && npm cache clean --force;

# nest
RUN npm install -g @nestjs/cli && npm cache clean --force;

# prisma
RUN npm install -g prisma && npm cache clean --force;

RUN npm install -g graphql-cli && npm cache clean --force;

RUN npm install -g ts-proto && npm cache clean --force;

RUN apk -U --no-cache add protobuf protobuf-dev

# ncu -u
RUN npm install -g npm-check-updates && npm cache clean --force;