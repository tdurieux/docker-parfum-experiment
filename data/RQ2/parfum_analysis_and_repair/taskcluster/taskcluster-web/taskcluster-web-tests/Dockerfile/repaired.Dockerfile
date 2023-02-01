FROM node:10
RUN apt-get update && apt-get install --no-install-recommends -y firefox-esr xvfb && rm -rf /var/lib/apt/lists/*;
