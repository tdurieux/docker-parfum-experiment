FROM node:7

RUN apt-get update && apt-get -y --no-install-recommends install libpng12-0 git && rm -rf /var/lib/apt/lists/*;

WORKDIR /brewpi-ui
COPY . .
RUN chmod +x post-install.sh
RUN npm install --loglevel=warn --unsafe-perm && npm cache clean --force;
RUN npm run build --loglevel=warn --unsafe-perm

EXPOSE 3000
CMD ["npm", "run", "start:prod"]
