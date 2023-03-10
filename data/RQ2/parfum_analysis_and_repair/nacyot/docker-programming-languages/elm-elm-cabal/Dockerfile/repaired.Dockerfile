FROM nacyot/haskell-ghc:apt
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get install --no-install-recommends -y libgc-dev llvm-3.3-dev libghc-terminfo-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Install elm
RUN cabal update
RUN cabal install aeson-0.7.0.6
RUN cabal install elm elm-server elm-repl elm-get

# Install nodejs for repl
RUN apt-get install --no-install-recommends -y node && rm -rf /var/lib/apt/lists/*;

# ADd Symbolic link
RUN bash -c "ln -s /root/.cabal/bin/{elm,elm-doc,elm-get,elm-repl,elm-server} /usr/local/bin/"

# Set default WORKDIR
WORKDIR /source
