FROM node:8.17

# Install designer
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Update package and install some module
RUN apt-get update && apt-get -qq --no-install-recommends -y install pdftk && apt-get -y --no-install-recommends install nano && apt-get -y --no-install-recommends install mysql-client && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/app

# (Re)install generator node modules
RUN rm -rf node_modules/
# RUN npm install

# Workspace modules install
RUN mkdir -p /usr/src/app/workspace && rm -rf /usr/src/app/workspace
COPY /structure/template/package.json /usr/src/app/workspace
# RUN cd /usr/src/app/workspace && npm install

VOLUME /usr/src/app/workspace
EXPOSE 1337 9001-9100

# Setup for ssh onto github
# RUN mkdir -p /root/.ssh
# ADD id_rsa /root/.ssh/id_rsa
# RUN chmod 700 /root/.ssh/id_rsa
# ADD ssh_config /root/.ssh/config

RUN cd /usr/src/app
RUN chmod 777 /usr/src/app/entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]