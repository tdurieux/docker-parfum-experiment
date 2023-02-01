FROM debian
RUN export node_version="0.10" \
  && apt-get update && apt-get -y --no-install-recommends install nodejs="$node_verion" && rm -rf /var/lib/apt/lists/*;
COPY package.json usr/src/app
RUN cd /usr/src/app \
  && npm install node-static && npm cache clean --force;

EXPOSE 80000
CMD ["npm", "start"]