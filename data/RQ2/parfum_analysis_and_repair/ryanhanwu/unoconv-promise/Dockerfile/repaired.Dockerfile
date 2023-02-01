FROM ryanhanwu/docker-filepreview:latest

# Install Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /prj
COPY ./package.json /prj/package.json
COPY ./package-lock.json /prj/package-lock.json
RUN npm install && npm cache clean --force;

COPY . /prj

ENTRYPOINT [""]


