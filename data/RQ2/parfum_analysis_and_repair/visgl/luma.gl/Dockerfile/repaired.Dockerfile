# Docker Image for BuildKite CI
# -----------------------------

FROM node:8.9.0

WORKDIR /luma-gl
ENV PATH /luma-gl/node_modules/.bin:$PATH

ENV DISPLAY :99

RUN apt-get update && apt-get -y --no-install-recommends install libxi-dev libgl1-mesa-dev xvfb && rm -rf /var/lib/apt/lists/*;

ADD .buildkite/xvfb /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb

COPY package.json yarn.lock /luma-gl/

RUN yarn
