FROM mono

RUN nuget update -self

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g gulp mocha && npm cache clean --force;

WORKDIR /data
