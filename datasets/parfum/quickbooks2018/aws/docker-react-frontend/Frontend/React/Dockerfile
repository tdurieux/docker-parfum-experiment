FROM node:latest as builder

WORKDIR /reactjs

#1 Install OS Libraries dependencies, if needed
# PUT HERE



#2 Install App Dependencies

# COPY package.json .


COPY myapp .

RUN apt update -y

RUN npm install



#3 Compile/transpile & package



RUN npm run build

RUN yarn

FROM nginx:latest as runtime

WORKDIR /usr/share/nginx/html

COPY nginx/ /etc/nginx/conf.d/

#4 Copy artifact - static website

COPY --from=builder /reactjs/build .

#5 entrypoint/cmd already comes with base image (nginx or apache)
