FROM haskell:8.10

RUN mkdir /app

WORKDIR app

RUN cabal v2-update
RUN cabal v2-install --lib hspec-2.7.6 QuickCheck-2.14.2 aeson-1.5.4.1 parsec-3.1.14.0 random-1.2.0 mtl-2.2.2
