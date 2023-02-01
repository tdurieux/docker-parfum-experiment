FROM ubuntu:disco
MAINTAINER jblee94

RUN apt-get update

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpqxx-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-format && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libzmq3-dev && rm -rf /var/lib/apt/lists/*;

# Use /bin/bash as a default shell
SHELL ["/bin/bash", "-c"]

ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR

ENV NODE_VERSION 10.16.3
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

# install node and npm LTS
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation of node
RUN node -v
RUN npm -v

RUN git clone https://github.com/kev0960/modoocode --depth=1
WORKDIR /modoocode

RUN npm install && npm cache clean --force;

ENV HASH_ROUNDS 8
ENV SESSION_SECRET do_num_run_on_prod_server
ENV SERVER_ENV DEBUG
ENV IN_WINDOWS_FOR_DEBUG true
ENV FB_APP_ID redacted
ENV FB_APP_SECRET redacted
ENV GOOG_CLIENT_ID redacted
ENV GOOG_CLIENT_SEC redacted
ENV GOOGLE_APPLICATION_CREDENTIALS ../auth.json

COPY auth.json /modoocode/auth.json
COPY .env /modoocode/.env

EXPOSE 8080
