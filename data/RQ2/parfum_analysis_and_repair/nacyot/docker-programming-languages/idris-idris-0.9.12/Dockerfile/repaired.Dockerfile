FROM nacyot/haskell-ghc:apt
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get install --no-install-recommends -y libgc-dev llvm-3.3-dev libghc-terminfo-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Install Idris
RUN cabal update
RUN cabal install idris-0.9.12

RUN bash -c "ln -s /root/.cabal/bin/idris /usr/local/bin/"

# Set default WORKDIR
WORKDIR /source
