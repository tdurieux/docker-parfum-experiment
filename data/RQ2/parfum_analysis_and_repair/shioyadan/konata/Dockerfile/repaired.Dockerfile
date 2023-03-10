FROM node:carbon

WORKDIR /usr/src/app

RUN apt-get update -y && apt-get install --no-install-recommends -y \
        nodejs \
        npm \
        libgtk-3-0 \
        libxss1 \
        libgconf2-4 \
        libnss3 \
        libasound2 \
	libX11-xcb1 \
	libcanberra-gtk3-module && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./

RUN npm install electron && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .

CMD ["node_modules/.bin/electron", "."]

# To run:
# docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix <docker image name>
