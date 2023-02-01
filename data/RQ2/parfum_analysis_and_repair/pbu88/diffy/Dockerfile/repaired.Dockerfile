FROM node:16.7.0

# Create a /diffy directory that will contain the application's code
RUN mkdir -p /diffy/backend
RUN mkdir -p /diffy/frontend

RUN npm install -g typescript@4.3.5 && npm cache clean --force;
# Angular stuff (cli and dev)
RUN npm install -g @angular/cli@12.2.2 && npm cache clean --force;

# Frontend
COPY ./frontend/ /diffy/frontend/
WORKDIR /diffy/frontend
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm run-script build

# Backend
COPY ./backend/ /diffy/backend/
WORKDIR /diffy/backend
RUN npm install && npm cache clean --force;
RUN npm run-script build

# Models
COPY ./models/ /diffy/models/
WORKDIR /diffy/models
RUN npm install && npm cache clean --force;
RUN npm run-script build

# By default expose port 3000 and run `node /diffy/src/app.js` when executing the image
EXPOSE 3000
CMD ["npm", "start"]
