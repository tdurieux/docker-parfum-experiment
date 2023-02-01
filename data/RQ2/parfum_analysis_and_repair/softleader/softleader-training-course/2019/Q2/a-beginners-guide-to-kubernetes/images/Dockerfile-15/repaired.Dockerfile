FROM nginx:1.15.10

RUN apt-get update && apt-get install --no-install-recommends curl -y && apt-get autoclean && rm -rf /var/lib/apt/lists/*;
