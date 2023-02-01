FROM node:8-onbuild
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
