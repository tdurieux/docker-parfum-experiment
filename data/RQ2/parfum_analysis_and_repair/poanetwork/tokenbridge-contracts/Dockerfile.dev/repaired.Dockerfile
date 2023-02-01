FROM node:10

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

WORKDIR /contracts

COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;

COPY ./deploy/package.json ./deploy/
COPY ./deploy/package-lock.json ./deploy/
RUN cd ./deploy; npm install; npm cache clean --force; cd ..

COPY truffle-config.js truffle-config.js
COPY ./contracts ./contracts
RUN npm run compile

COPY flatten.sh flatten.sh
RUN bash flatten.sh

COPY .eslintignore .eslintignore
COPY .eslintrc .eslintrc
COPY .prettierrc .prettierrc

COPY deploy.sh deploy.sh
COPY ./deploy ./deploy
COPY .solhint.json .solhint.json
COPY codechecks.yml codechecks.yml
COPY ./test ./test

ENV PATH="/contracts/:${PATH}"
ENV NOFLAT=true
