# vscode only supports older node
FROM node:10
RUN apt-get update && apt-get install --no-install-recommends libsecret-1-dev libx11-dev libxkbfile-dev -y && rm -rf /var/lib/apt/lists/*;
RUN npm i -g yarn --force && npm cache clean --force;
RUN git clone https://github.com/microsoft/vscode.git /vscode
WORKDIR /vscode
RUN git pull
COPY --from=typescript/typescript /typescript/typescript-*.tgz /typescript.tgz
WORKDIR /vscode/build
RUN yarn add typescript@/typescript.tgz
WORKDIR /vscode/extensions
RUN yarn add typescript@/typescript.tgz
WORKDIR /vscode
RUN yarn add typescript@/typescript.tgz
RUN yarn
ENTRYPOINT [ "yarn" ]
# Build
CMD [ "compile" ]