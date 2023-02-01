FROM verdaccio/verdaccio:4.2.2
USER root
RUN npm i && npm i verdaccio-ldap && npm cache clean --force;
USER verdaccio