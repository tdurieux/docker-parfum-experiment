FROM daocloud.io/node
WORKDIR /app
COPY . /app/
RUN npm install && npm cache clean --force;
RUN npm run build
RUN cp -r src/db dist/
CMD ["npm","run","production"]

EXPOSE 3000