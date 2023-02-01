FROM node:8

RUN mkdir /code
WORKDIR /code
COPY package-lock.json .
COPY package.json .

RUN apt-get -qq update \
    && apt-get -qq -y --no-install-recommends install netcat \
    && apt-get clean && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/* \
    && npm install -q && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENV PATH="/code/node_modules/.bin:${PATH}"
VOLUME ["/code"]
EXPOSE 8545
CMD ["truffle"]
