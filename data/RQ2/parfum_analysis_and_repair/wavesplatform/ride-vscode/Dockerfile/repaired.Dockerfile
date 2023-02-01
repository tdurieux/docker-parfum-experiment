FROM node:15
ARG token
WORKDIR /app
COPY . /app
RUN npm install --unsafe-perm && npm cache clean --force;
#RUN cd extension && npm install && cd ../server && npm install && cd ..
RUN npm install -g vsce && npm cache clean --force;
RUN vsce publish -p $token
