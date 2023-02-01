# base image
FROM node:13.14@sha256:1e8d7127072cdbaae1935656444c3ec2bef8882c8c14d459e3a92ca1dd313c28 as builder

# set working directory
RUN  mkdir /usr/local/app
WORKDIR /usr/local/app

# This is only for the build and not needed if running locally
COPY ./package-lock.json /usr/local/app/package-lock.json
COPY ./package.json /usr/local/app/package.json
RUN npm ci 
# Because: https://stackoverflow.com/questions/37715224/copy-multiple-directories-with-one-command
COPY ./src/ ./src/

COPY ["angular.json", "tsconfig.json", "tsconfig.app.json", "tsconfig.spec.json", "tslint.json", "./"]
RUN npm run build



##################
### production ###
##################