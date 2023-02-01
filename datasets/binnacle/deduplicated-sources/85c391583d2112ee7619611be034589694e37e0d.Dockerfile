FROM node:8.4.0  
# npm5 issue with updating itself: https://github.com/npm/npm/issues/18278  
# RUN npm install -g npm@latest  
WORKDIR /code  
  
COPY package.json package.json  
COPY package-lock.json package-lock.json  
COPY elm-package.json elm-package.json  
COPY gulpfile.js gulpfile.js  
  
RUN npm install  
  
# npm5 issue w/ postinstall: https://github.com/npm/npm/issues/17316  
RUN ./node_modules/.bin/elm-package install --yes  
  
COPY ./jarbas /code/jarbas  
  
CMD ["npm", "run", "watch"]  

