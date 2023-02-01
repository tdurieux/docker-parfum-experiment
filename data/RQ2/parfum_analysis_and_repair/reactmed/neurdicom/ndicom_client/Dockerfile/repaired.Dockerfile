FROM node

WORKDIR /app

COPY package.json package-lock.json ./

CMD [ npm i npm@latest -g && npm cache clean --force;]
CMD [ npm install && npm cache clean --force;]
#CMD npm run build