FROM gcc:7


    RUN apt-get update && apt-get install -y --no-install-recommends bison flex && rm -rf /var/lib/apt/lists/*;

COPY ./ /src/peylang
WORKDIR /src/peylang

