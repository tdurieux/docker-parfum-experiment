FROM ubuntu

RUN apt-get update -y && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*; #!COMMIT
