ARG BRANCH
FROM mse-player-prepare:${BRANCH}

WORKDIR /root

ADD src src
ADD .babelrc .
ADD .npmignore .
ADD package.json .
ADD webpack.config.js .
ADD webpack.config.frontci.js .
ADD yarn.lock .
ADD deploy deploy
ADD package.json .
ADD CHANGELOG.md .
ADD README.md .
ADD LICENSE .

RUN mkdir -p /root/.ssh && chown 0600 /root/.ssh && cp deploy/id_rsa /root/.ssh && chown 0400 /root/.ssh/id_rsa*
RUN echo 'git.erlyvideo.ru ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbjUZh2ZZZTng8BdZP+aTjkfq1eUV8x9VKtx8Svtcg7oG16jAXMLklfMA0FNNzvVJfCN6PNi2s5eMY+yYXoJnDXJsCO5cWKi4lro4E6OlWrgP78nBVI1LGBdD7a09ygypcvQm842Uo0sp+6tbWoWaevye9qjmj0kzzMq5iGawEf3GSBjVA5tfIHWQrNMNLcWsUehnsSsbgsvWijzabhp/UEJif0vuADVfQNQdQYJs2FTtvAzOckLIreAAEeQuMBy450ZLppW/J4mFbfGcXKUUOsEuXw5EUpXv3DvlbRoppuKg5bCWGiIqDToXEdh0qy2wFdoNJBOtBYemBncAx8EbZ' >> /root/.ssh/known_hosts

RUN yarn install && yarn cache clean;
