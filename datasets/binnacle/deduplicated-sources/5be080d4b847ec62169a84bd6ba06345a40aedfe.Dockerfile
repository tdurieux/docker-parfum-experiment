FROM ubuntu

# make sure apt is up to date
RUN apt-get update

# install nodejs and npm
RUN apt-get install -y nodejs npm #git git-core

ADD . /api/

#RUN chmod +x /api/server.js

RUN cd /api/; npm install

EXPOSE 8000
CMD /usr/bin/nodejs /api $ADDRESS 8000