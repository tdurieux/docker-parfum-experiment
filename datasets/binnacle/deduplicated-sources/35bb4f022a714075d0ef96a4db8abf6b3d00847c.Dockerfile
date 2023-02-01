FROM node:8-alpine
ARG basedir="app"
ARG build_info="Docker container build"
ENV NODE_ENV production
ENV BUILD_INFO $build_info
# Place our app here
WORKDIR /home/app

# NPM install packages
COPY ${basedir}/package*.json ./
RUN npm install --production --silent

# NPM is done, now copy in the the whole project to the workdir
COPY ${basedir}/*.js ./

EXPOSE 80
ENTRYPOINT [ "npm" , "start" ]