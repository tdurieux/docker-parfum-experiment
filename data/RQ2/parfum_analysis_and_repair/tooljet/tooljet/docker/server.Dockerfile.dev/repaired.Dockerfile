# pull official base image
FROM node:14.17.3-buster
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client freetds-dev libaio1 wget && rm -rf /var/lib/apt/lists/*;

# Install Instantclient Basic Light Oracle and Dependencies
WORKDIR /opt/oracle
RUN wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip && \
    unzip instantclient-basiclite-linuxx64.zip && rm -f instantclient-basiclite-linuxx64.zip && \
    cd /opt/oracle/instantclient* && rm -f *jdbc* *occi* *mysql* *mql1* *ipc1* *jar uidrvci genezi adrci && \
    echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig
WORKDIR /

ENV NODE_ENV=development
ENV NODE_OPTIONS="--max-old-space-size=4096"

RUN npm i -g npm@7.20.0 && npm cache clean --force;
RUN mkdir -p /app
WORKDIR /app

COPY ./package.json ./package.json

# install app dependencies
COPY ./server/package.json ./server/package-lock.json ./server/
RUN npm --prefix server install && npm cache clean --force;
COPY ./server/ ./server/

ENTRYPOINT ["./server/entrypoint.sh"]
