FROM ubuntu:14.04

# Install Node.js and npm
RUN apt-get update && apt-get install --no-install-recommends -y nodejs npm git git-core mysql-server curl wget && rm -rf /var/lib/apt/lists/*;

# Bundle app source
COPY . /home/uncovery

# Install app dependencies
RUN cd /home/uncovery; npm install && npm cache clean --force;
RUN npm install -g n && npm cache clean --force;
RUN n stable

EXPOSE 3000

CMD /home/uncovery/installer.sh
