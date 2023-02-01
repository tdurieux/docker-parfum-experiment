FROM dialect/protocol:latest

# Install npm dependencies
COPY ./package.json ./
RUN npm i && npm cache clean --force;
RUN npm i -g typescript ts-mocha && npm cache clean --force;

COPY ./src ./src
COPY ./tests ./tests
COPY ./tsconfig.json ./

CMD ["anchor", "test"]
