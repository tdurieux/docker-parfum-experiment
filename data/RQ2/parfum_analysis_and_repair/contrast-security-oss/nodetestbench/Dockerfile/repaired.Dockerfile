ARG node_version

FROM node-agent
FROM node:$node_version

WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;

COPY --from=node-agent /agent/agent.tgz .
RUN npm install agent.tgz && npm cache clean --force;

# CMD npm run contrast
# CMD npm run contrast -- \
# --skipAutoUpdate --appActivityPeriod 6000 --mute \
# --appname NodeTestBench-${NODE_VERSION} \
# --apiKey ${API_KEY} --uri ${TEAMSERVER_URI}
