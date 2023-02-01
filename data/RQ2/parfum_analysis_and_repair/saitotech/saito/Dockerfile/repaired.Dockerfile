FROM node:10-jessie

RUN apt-get update && apt-get -y --no-install-recommends install g++ make git sudo && rm -rf /var/lib/apt/lists/*;

COPY ./ /saito

WORKDIR /saito/extras/sparsehash/sparsehash


RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

WORKDIR /saito
RUN npm install && npm cache clean --force;

RUN cd ./lib && ./compile nuke

CMD node ./lib/start.js
