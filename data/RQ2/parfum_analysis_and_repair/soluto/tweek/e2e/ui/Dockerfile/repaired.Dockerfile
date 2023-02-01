FROM testcafe/testcafe:1.9.4
USER root

COPY package.json yarn.lock /src/
RUN cd /src && npm i --production && npm cache clean --force;
COPY . /src

USER user
