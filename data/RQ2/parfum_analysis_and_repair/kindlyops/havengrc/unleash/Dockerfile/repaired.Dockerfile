FROM havengrc-docker.jfrog.io/unleashorg/unleash-server:3.2

RUN npm install @exlinc/keycloak-passport && npm cache clean --force;
RUN npm install basic-auth && npm cache clean --force;


COPY *.js ./
COPY frontend /
