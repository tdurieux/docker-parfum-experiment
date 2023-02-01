FROM teamcodestream/centos-base:1.0.0

ADD . /opt/api/api_server
WORKDIR /opt/api
RUN mkdir log tmp pid

{% include 'extras/buildvars.env' %}

# See docker-compose.yml env_file parameter for runtime configuration parameters

WORKDIR /opt/api/api_server
RUN npm install --no-save && npm cache clean --force;

EXPOSE 12079

# CMD [ "node", "bin/api_server.js", "--one_worker" ]
CMD [ "/opt/api/api_server/bin/cs_api-start-docker" ]
