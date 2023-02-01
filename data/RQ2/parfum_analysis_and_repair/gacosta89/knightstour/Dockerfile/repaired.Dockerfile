FROM node:argon
EXPOSE 3000
WORKDIR "/home/knightsTour"
ADD . ./
RUN cd /home/knightsTour && npm install && npm cache clean --force;
CMD ["npm", "start"]
