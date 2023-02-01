FROM ubuntu:16.04 as react

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git curl libfontconfig && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends nodejs-legacy -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends npm -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install sass -v 3.2.19

WORKDIR /code

ADD . /code

RUN npm link gulp

RUN npm cache clean --force -f
RUN npm install -g n && npm cache clean --force;
RUN n stable

RUN npm install && npm cache clean --force;

RUN npm install --save-dev json-loader && npm cache clean --force;

RUN npm install -g webpack@1.13.1 && npm cache clean --force;

RUN webpack

FROM nginx:1.13-alpine
COPY docker/prod/reactjs/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=react /code /code
