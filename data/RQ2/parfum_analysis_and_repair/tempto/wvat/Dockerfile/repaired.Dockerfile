FROM node:10

RUN apt-get update
RUN apt-get install --no-install-recommends -y p7zip-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nsis && rm -rf /var/lib/apt/lists/*;
