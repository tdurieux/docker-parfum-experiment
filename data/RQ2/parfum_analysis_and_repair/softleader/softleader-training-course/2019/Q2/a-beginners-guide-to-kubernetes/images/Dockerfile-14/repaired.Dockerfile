FROM nginx:1.14.2

RUN apt-get update && apt-get install --no-install-recommends curl -y && apt-get autoclean && rm -rf /var/lib/apt/lists/*;
