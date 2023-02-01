FROM node:12.16.1
LABEL version="1.2"
LABEL description="Projects microservice"
RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

RUN apt-get update && \
    apt-get upgrade -y

# install aws
RUN apt-get install --no-install-recommends -y \
    ssh \
    python \
    python-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

RUN apt-get install -y --no-install-recommends libpq-dev && rm -rf /var/lib/apt/lists/*;
# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Bundle app source
COPY . /usr/src/app
# Install app dependencies
RUN npm install && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT ["npm","run"]
#CMD ["npm", "start"]
