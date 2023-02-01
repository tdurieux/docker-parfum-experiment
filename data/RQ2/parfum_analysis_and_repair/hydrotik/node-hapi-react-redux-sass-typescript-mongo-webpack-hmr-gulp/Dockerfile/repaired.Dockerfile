FROM node:boron

# Create app directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install app dependencies (Doing this first takes advantage of Docker's caching of layers)
RUN apt-get install --no-install-recommends -y make gcc g++ python git && rm -rf /var/lib/apt/lists/*;
COPY package.json /opt/app/
COPY plugins/auth_plugin/package.json /opt/app/plugins/auth_plugin/
COPY plugins/navbobulator/package.json /opt/app/plugins/navbobulator/
COPY plugins/contentedit/package.json /opt/app/plugins/contentedit/
RUN npm install && npm cache clean --force;


# Bundle app source
COPY . /opt/app
RUN cd plugins/auth_plugin && npm link && cd ../../
RUN cd plugins/navbobulator && npm link && cd ../../
RUN cd plugins/contentedit && npm link && cd ../../
RUN npm link auth_plugin navbobulator contentedit


EXPOSE 8000
EXPOSE 8001
EXPOSE 8008

CMD [ "npm", "start" ]
