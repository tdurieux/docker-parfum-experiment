FROM mhart/alpine-node
MAINTAINER Denis Carriere - carriere.denis@gmail.com

# Install app dependencies
WORKDIR /src
ADD . .
RUN npm install && npm cache clean --force;

# Run App
EXPOSE 8080
CMD ['npm', 'start']
