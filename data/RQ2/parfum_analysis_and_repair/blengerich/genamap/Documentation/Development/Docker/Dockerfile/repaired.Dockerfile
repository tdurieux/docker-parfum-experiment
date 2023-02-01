FROM blengerich/genamap
WORKDIR GenAMap_V2/frontend/genamapApp
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["node", "webapp.js"]