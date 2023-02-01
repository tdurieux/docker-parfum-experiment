FROM buildkite/puppeteer:8.0.0
RUN rm -rf /node_modules /package.json /package-lock.json
RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    fonts-roboto \
    fonts-noto-cjk \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-kacst \
    fonts-freefont-ttf \
    fonts-thai-tlwg \
    fonts-indic && \
    apt-get -qyy clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /renderer
COPY package.json yarn.lock .yarnclean ./
RUN yarn install && yarn cache clean;
COPY tsconfig.json .
COPY src src
RUN yarn build && yarn cache clean;
ENTRYPOINT [ "node", "dist/lib/docker-entrypoint.js" ]
