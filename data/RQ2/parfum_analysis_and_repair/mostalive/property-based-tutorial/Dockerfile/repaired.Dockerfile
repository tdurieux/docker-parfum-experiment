FROM capitalmatch/haskell-desktop

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl gedit && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:webupd8team/sublime-text-2 && \
    apt-get update && \
    apt-get install -y --no-install-recommends sublime-text && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/dockerx

ADD clone-or-pull.sh clone-or-pull.sh

RUN ./clone-or-pull.sh https://github.com/qwaneu/property-based-tutorial joy

RUN cd joy/exercises/js && \
    npm install jsverify && \
    npm install underscore && npm cache clean --force;

RUN cd joy/exercises/hsmoney && \
    cabal install --only-dependencies

RUN chown -R dockerx.dockerx joy

