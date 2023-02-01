FROM node:5.6.0-slim  
  
WORKDIR /opt/burrow-stats  
ADD package.json package.json  
RUN npm install  
ADD . .  
ENV NODE_ENV=production  
RUN npm run build  
ADD conf/configs.json /opt/burrow-stats/configs.json  
CMD npm start  

