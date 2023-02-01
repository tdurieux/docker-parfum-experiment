FROM node

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
    libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

# Setup PATH to prioritize local npm bin ahead of system PATH.
ENV PATH node_modules/.bin:$PATH

RUN mkdir /code
WORKDIR /code

COPY package.json /code/
RUN SKIP_POSTINSTALL=1 npm install --silent && npm cache clean --force;

COPY .bowerrc /code/
COPY bower.json /code/
RUN GIT_DIR=/tmp bower install --allow-root --silent

COPY . /code/

EXPOSE 8081
EXPOSE 3000

CMD npm start
