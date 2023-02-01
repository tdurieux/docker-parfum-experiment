FROM node:8.9.0

WORKDIR /deck-gl
ENV PATH /deck-gl/node_modules/.bin:$PATH

# Install XVFB dependencies into container
ENV DISPLAY :99
ADD .buildkite/xvfb /etc/init.d/xvfb

RUN apt-get update && apt-get -y --no-install-recommends install xvfb && chmod a+x /etc/init.d/xvfb && rm -rf /var/lib/apt/lists/*;

COPY package.json yarn.lock /deck-gl/

RUN yarn && yarn cache clean;
