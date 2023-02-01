FROM python:3

COPY . /solana-workbench
WORKDIR /solana-workbench
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
ENV DEBUG electron-rebuild
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python

# Need Typescript, etc. for native extension build to work
RUN npm install && npm cache clean --force;
RUN (cd ./release/app npm install)
RUN npm build
