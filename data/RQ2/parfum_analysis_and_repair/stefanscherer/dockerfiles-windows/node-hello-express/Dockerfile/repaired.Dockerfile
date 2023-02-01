FROM stefanscherer/node-windows:10
WORKDIR /code
COPY package.json /code
RUN npm install --production && npm cache clean --force;
COPY . /code
CMD ["node", "app.js"]
