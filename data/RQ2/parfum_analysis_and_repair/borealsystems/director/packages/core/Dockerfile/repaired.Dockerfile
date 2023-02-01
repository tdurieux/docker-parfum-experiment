FROM node:14.15.3
RUN apt-get update && apt-get install --no-install-recommends udev libusb-1.0-0-dev git cmake build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://phabricator.boreal.systems/source/Director.git /borealsystems/director --recursive
WORKDIR /borealsystems/director
RUN yarn workspace core install
RUN yarn workspace core run build && yarn cache clean;

EXPOSE 3000

CMD yarn workspace core run prod