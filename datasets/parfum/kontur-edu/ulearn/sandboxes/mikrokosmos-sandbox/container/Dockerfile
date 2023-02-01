FROM haskell:8.0.2

RUN mkdir /app

WORKDIR app

RUN apt-get update && apt-get install -y \
    python3 \
 && rm -rf /var/lib/apt/lists/*

RUN cabal update
RUN cabal install mikrokosmos-0.8.0
