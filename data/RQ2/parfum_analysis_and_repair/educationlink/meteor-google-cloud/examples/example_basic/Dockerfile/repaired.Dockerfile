FROM gcr.io/google_appengine/nodejs
RUN install_node {{ nodeVersion }}
RUN npm install npm@{{ npmVersion }} && npm cache clean --force;
RUN node -v
RUN npm -v
COPY . /app/
RUN ( cd programs/server && npm install --unsafe-perm) && npm cache clean --force;
CMD node main.js
