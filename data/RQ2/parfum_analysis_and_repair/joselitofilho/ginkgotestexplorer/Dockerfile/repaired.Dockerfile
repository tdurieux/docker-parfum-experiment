FROM golang:1.15.3
RUN apt-get update
RUN apt-get install --no-install-recommends -y git python jq curl vim && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install gulp -g \
    && npm install yarn -g \
    && npm install -g yo generator-code \
    && npm install -g vsce && npm cache clean --force;

WORKDIR /src

COPY . .
