FROM node:10
RUN npm install -g proxy && npm cache clean --force;
CMD proxy
EXPOSE 3128
