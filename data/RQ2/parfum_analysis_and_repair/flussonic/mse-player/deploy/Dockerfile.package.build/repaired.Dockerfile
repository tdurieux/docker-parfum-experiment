ARG BRANCH
FROM mse-player-dependencies:${BRANCH}

WORKDIR /root
RUN yarn build && yarn cache clean;
