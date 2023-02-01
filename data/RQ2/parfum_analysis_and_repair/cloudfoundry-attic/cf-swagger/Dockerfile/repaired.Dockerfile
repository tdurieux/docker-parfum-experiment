###
# swagger-editor - https://github.com/swagger-api/swagger-editor/
#
# Run the swagger-editor service on port 8080
###

FROM registry-ice.ng.bluemix.net/ibmnode:latest
COPY id_med_rsa.pub /root/.ssh/
RUN cat /root/.ssh/id_med_rsa.pub >> /root/.ssh/authorized_keys

MAINTAINER Marcello_deSales@intuit.com

ENV     DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git npm nodejs && rm -rf /var/lib/apt/lists/*;
#RUN     ln -s /usr/bin/nodejs /usr/local/bin/node

WORKDIR /runtime
ADD     package.json    /runtime/package.json
#RUN     npm install

RUN npm install -g bower grunt-cli && npm cache clean --force;


ADD     bower.json      /runtime/bower.json
ADD     .bowerrc        /runtime/.bowerrc
RUN     bower --allow-root install

ADD     .   /runtime
RUN 	grunt build

# The default port of the application
EXPOSE  8080
CMD     grunt connect:dist
