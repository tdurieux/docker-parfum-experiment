FROM julia:latest

RUN apt-get update && apt-get install --no-install-recommends -y gcc apt-utils unzip make libhttp-parser-dev && rm -rf /var/lib/apt/lists/*;
