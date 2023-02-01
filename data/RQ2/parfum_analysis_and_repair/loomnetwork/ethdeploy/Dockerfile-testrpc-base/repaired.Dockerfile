FROM node:6

RUN apt install --no-install-recommends -y make gcc g++ python git bash && rm -rf /var/lib/apt/lists/*;
COPY package.json /src/package.json

WORKDIR /src
RUN npm install && npm cache clean --force;

ADD tmp/testrpc .

EXPOSE 8081

CMD ["/bin/bash"]

