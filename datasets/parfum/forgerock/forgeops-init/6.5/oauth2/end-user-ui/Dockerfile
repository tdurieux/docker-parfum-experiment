FROM gcr.io/forgerock-io/end-user-ui:6.5.0

WORKDIR /tmp/end-user-ui

RUN git remote add jakefeasel https://github.com/jakefeasel/end-user-ui.git && git fetch jakefeasel && git checkout oauth2

RUN npm install && npm run build

WORKDIR /tmp/end-user-ui/dist
