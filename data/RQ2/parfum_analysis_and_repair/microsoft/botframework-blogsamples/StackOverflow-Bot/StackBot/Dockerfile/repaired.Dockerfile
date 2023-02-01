FROM node:8-onbuild
EXPOSE 3978
RUN npm install && npm cache clean --force;
CMD ["npm", "run", "start"]
