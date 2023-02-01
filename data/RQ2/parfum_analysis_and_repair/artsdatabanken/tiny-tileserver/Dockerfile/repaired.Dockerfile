FROM node:10 as dep

COPY package.json package-lock.json ./

RUN apt install -y --no-install-recommends python libpixman-1-dev libpixman-1-0 && rm -rf /var/lib/apt/lists/*;
RUN npm install --production && npm cache clean --force;

FROM node:10
RUN groupadd --gid 1007 dockerrunner && useradd -r --uid 1007 -g dockerrunner dockerrunner
WORKDIR /app
COPY --from=dep /node_modules ./node_modules
EXPOSE 8000
ADD . .
CMD [ "node", "tiny-tileserver.js", "--port", "8000", "/data/" ]
