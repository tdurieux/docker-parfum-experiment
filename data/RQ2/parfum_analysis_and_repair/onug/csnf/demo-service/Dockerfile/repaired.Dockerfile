FROM pcampbe/csnf-image
WORKDIR /app
COPY package.json .
RUN npm install && npm install typescript -g && npm cache clean --force;
COPY . ./
RUN tsc
ENV PORT 3000
EXPOSE $PORT
CMD ["node", "./dist/server.js"]