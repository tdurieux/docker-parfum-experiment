FROM node:4.5

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /paypal-checkout-demo

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# npm
COPY package.json $APP_HOME
RUN npm install && npm cache clean --force;

# build the app
COPY .babelrc $APP_HOME
COPY webpack.conf.js $APP_HOME
COPY src $APP_HOME/src
RUN npm run build
