FROM emscripten/emsdk:2.0.25
WORKDIR /web-ifc-app
COPY package*.json .
RUN npm i -g cpy-cli && npm cache clean --force;
RUN npm i && npm cache clean --force;
COPY . .
RUN npm run build-release-all
EXPOSE 3000
ENTRYPOINT [ "npm", "run", "dev" ]