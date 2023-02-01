FROM ubuntu:xenial
EXPOSE 80
EXPOSE 3000
# we overwrite default.conf to enable the location / directive
COPY default.conf /etc/nginx/conf.d/default.conf
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN apt -y update
RUN apt -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
# for purposes of this snippet prefer official install over
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN apt -y update
RUN apt -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/node/
# installs source
COPY ./static /var/node/static
RUN cd /var/node/static ; npm install && npm cache clean --force;
# requires the execute bit (chmod +x be set prior to copying)
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
