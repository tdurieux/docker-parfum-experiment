FROM node:argon-stretch

RUN npm install -g bower && npm cache clean --force;
RUN npm install -g gulp-cli && npm cache clean --force;

ENV user node
RUN groupadd -f $user && useradd --create-home --gid $user $user || true

# Create app directory
RUN mkdir -p /home/$user/pushserver
WORKDIR /home/$user/pushserver

# Install app dependencies
COPY package.json /home/$user/pushserver
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /home/$user/pushserver
RUN mkdir /home/$user/pushserver/logs
RUN chown -R $user:$user /home/$user
USER $user
RUN bower install
RUN gulp build
RUN gulp syncDb

VOLUME ["/home/$user/db"]
VOLUME ["/home/$user/logs"]
EXPOSE 3000
CMD [ "gulp", "watch" ]
