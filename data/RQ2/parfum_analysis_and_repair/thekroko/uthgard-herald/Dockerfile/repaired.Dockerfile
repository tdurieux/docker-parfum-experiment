FROM nginx


env NODEREPO node_7.x
env DISTRO jessie
RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https git-core && rm -rf /var/lib/apt/lists/*;
RUN curl -f -v https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main > /etc/apt/sources.list.d/nodesource.list
RUN echo deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install --no-install-recommends -y nodejs build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./herald /tmp/herald
RUN cd /tmp/herald && npm install && npm run-script build -- -prod && rm -rf node_modules && npm cache clean --force;
RUN cd /tmp/herald/dist/ && cp -avr * /usr/share/nginx/html/.

COPY ./nginx/conf.d /etc/nginx/conf.d

EXPOSE 80
