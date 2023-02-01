FROM ubuntu:16.04
ARG mode=production

#Update ubuntu and install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y curl apt-transport-https gnupg vim && rm -rf /var/lib/apt/lists/*;

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs build-essential && rm -rf /var/lib/apt/lists/*;

# Install chrome
RUN curl -f -sL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
# RUN apt-key add ~/linux_signing_key.pub
RUN echo "deb https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst && rm -rf /var/lib/apt/lists/*;

# Install git and yarn (for browser extension)
RUN if [ $mode = "test" ]; then \
      echo "Test mode detected. Installing git and yarn." && \
      apt-get install --no-install-recommends software-properties-common -y && \
      curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      add-apt-repository ppa:git-core/ppa && \
      apt-get update && \
      apt-get install --no-install-recommends git yarn -y; rm -rf /var/lib/apt/lists/*; \
    else \
      echo "Production mode detected. Ignoring git and yarn."; \
    fi



WORKDIR /app

# Add a chrome user and setup home and app dir.
RUN groupadd --system chrome && \
    useradd --system --create-home --gid chrome --groups audio,video chrome && \
    mkdir --parents /home/chrome/reports && \
    chown --recursive chrome:chrome /home/chrome && \
    chown -R chrome:chrome /app

USER chrome

ENV DOCKER=true

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY . /app

RUN npm run build

# Install hint manually (just for browser extension tests)
RUN if [ $mode = "test" ]; then \
      echo "Test mode detected. Installing hint manually." && \
      rm -rf node_modules/hint && rm -rf gitrepos/ && \
      mkdir gitrepos && cd gitrepos && git clone https://github.com/webhintio/hint.git && cd hint/packages/hint && npm install && npm install @types/is-ci @types/proxyquire && npm run build && cd ../../../.. && \
      mkdir node_modules/hint && \
      cp -a gitrepos/hint/packages/hint node_modules/; npm cache clean --force; \
    else \
      echo "Production mode detected. Ignoring git and yarn."; \
    fi

# Create webhint bundle for browser extension.
RUN if [ $mode = "test" ]; then \
      echo "Test mode detected. Installing building webhint bundle for the browser extension." && \
      rm -rf gitrepos/hint/pacakges/hint/node_modules/ && cd gitrepos/hint && yarn && yarn build && \
      cd packages/extension-browser && yarn build && cd ../../../.. && \
      cp gitrepos/hint/packages/extension-browser/dist/bundle/content-script/webhint.js dist/src/lib/microservices/worker-service/webhint.js; \
    else \
      echo "Production mode detected. Ignoring git and yarn."; \
    fi

CMD node dist/src/bin/online-service.js --microservice worker
