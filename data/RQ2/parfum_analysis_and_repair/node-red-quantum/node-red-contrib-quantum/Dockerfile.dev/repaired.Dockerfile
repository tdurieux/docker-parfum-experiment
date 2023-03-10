# Pull image with python 3.9 and nodejs 16
FROM nikolaik/python-nodejs:python3.9-nodejs16
# nodemon provides hot reloading support
RUN npm install -g nodemon && npm cache clean --force;

WORKDIR /node-red-contrib-quantum

COPY package*.json ./

COPY bin ./bin

RUN npm run setup
# Expose 1880 port
EXPOSE 1880
# Run the initialisation script
ENTRYPOINT [ "./bin/start-dev-container.sh" ]