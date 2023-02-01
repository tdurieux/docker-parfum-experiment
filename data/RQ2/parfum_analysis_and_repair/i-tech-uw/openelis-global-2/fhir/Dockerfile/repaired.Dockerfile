FROM hapiproject/hapi:v5.4.1

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;