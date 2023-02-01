FROM node

COPY . .
RUN npm install --global babel-cli && npm cache clean --force;
RUN npm install --save-dev babel-core babel-preset-es2015 && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run transpile

WORKDIR /app
CMD "./start.sh"
