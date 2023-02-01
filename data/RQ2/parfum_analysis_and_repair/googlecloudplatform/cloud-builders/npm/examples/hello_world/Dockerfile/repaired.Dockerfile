FROM gcr.io/google-appengine/nodejs

WORKDIR /hello

COPY package.json /hello/
RUN npm install && npm cache clean --force;
COPY . /hello/

EXPOSE 3000

CMD ["npm", "start"]
