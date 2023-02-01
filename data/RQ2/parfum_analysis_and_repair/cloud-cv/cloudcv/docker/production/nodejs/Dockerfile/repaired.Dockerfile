FROM node:6
MAINTAINER CloudCV Team

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install sass

WORKDIR /code/
COPY ./frontend/ /code/
COPY ./docker/production/nodejs/container-start.sh /code/

# Install Prerequisites
RUN npm cache clean --force -f

RUN npm install -g yarn && npm cache clean --force;
RUN yarn install && yarn cache clean;

CMD ["/bin/bash", "/code/container-start.sh"]
EXPOSE 6003
