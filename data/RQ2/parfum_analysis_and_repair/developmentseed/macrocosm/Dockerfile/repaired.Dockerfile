FROM node:5.3

RUN wget -O - https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list && apt-get update && apt-get install --no-install-recommends -y postgresql-client-9.4 && rm -rf /var/lib/apt/lists/*;

ADD package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

WORKDIR /opt/app
ADD . /opt/app

EXPOSE 4000
CMD ["npm", "start"]
