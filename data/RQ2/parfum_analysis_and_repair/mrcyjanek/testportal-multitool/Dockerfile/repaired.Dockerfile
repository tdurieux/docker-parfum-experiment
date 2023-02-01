FROM debian:stable

RUN apt update && apt install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm install --global web-ext && npm cache clean --force;
