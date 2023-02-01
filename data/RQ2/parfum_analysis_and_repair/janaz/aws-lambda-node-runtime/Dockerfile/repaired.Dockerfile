FROM node:16.0.0-buster-slim

RUN apt-get update && apt-get install --no-install-recommends -y p7zip-full curl xz-utils gnupg && apt-get clean all && rm -rf /var/lib/apt/lists/*;
