FROM ubuntu

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install nodejs nodejs-legacy nodejs-dev npm git curl supervisor netcat-traditional && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm && npm cache clean --force;

# target directory for all applications
RUN mkdir /opt/raintank

# use a volume for our log directory so that it is not saved as part of the container.
VOLUME /var/log/raintank

