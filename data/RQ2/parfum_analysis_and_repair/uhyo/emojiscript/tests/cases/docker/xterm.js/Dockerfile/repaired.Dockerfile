# node-pty doesn't build on node 12 right now, so we lock to 8 - the version xterm itself tests against :(
FROM node:8
RUN git clone https://github.com/xtermjs/xterm.js.git /xtermjs
WORKDIR /xtermjs
RUN git pull
COPY --from=typescript/typescript /typescript/typescript-*.tgz /typescript.tgz
RUN mkdir /typescript
RUN tar -xzvf /typescript.tgz -C /typescript && rm /typescript.tgz
RUN npm i typescript@/typescript/package && npm cache clean --force;
RUN npm install && npm cache clean --force;
# Set entrypoint back to bash (`node` base image made it `node`)
ENTRYPOINT [ "/bin/bash", "-c" , "exec \"${@:0}\";"]
# Build
CMD npm run build