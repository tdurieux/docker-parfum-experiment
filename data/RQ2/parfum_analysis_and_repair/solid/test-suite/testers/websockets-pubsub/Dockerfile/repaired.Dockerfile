FROM node
ADD tester .
RUN npm install && npm cache clean --force;
CMD npm run jest
