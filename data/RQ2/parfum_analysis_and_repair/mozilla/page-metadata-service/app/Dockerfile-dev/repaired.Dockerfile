FROM app:build
RUN npm install && npm cache clean --force;
