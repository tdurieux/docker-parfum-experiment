FROM netsurf-build:latest

RUN apt-get update && apt-get install --no-install-recommends -y bear clangd && rm -rf /var/lib/apt/lists/*;
