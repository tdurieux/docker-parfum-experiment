FROM node
EXPOSE 8888
WORKDIR /home/app
RUN npm install --save express && npm cache clean --force;
RUN npm install --save uuid && npm cache clean --force;
RUN npm install --save jose && npm cache clean --force;
RUN npm install --save axios && npm cache clean --force;
RUN npm install --save oidc-client-ts && npm cache clean --force;
COPY * /home/app
CMD [ "npm", "start" ]
