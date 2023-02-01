FROM node

RUN apt-get update && apt-get install --no-install-recommends -y libnss3 libgtk-3-0 libx11-xcb1 libxss1 libasound2 && rm -rf /var/lib/apt/lists/*;
RUN npm install -g lerna && npm cache clean --force;

RUN mkdir -p /nuclear
WORKDIR /nuclear
ADD . /nuclear
