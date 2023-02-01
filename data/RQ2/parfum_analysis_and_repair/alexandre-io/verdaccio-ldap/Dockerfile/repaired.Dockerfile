FROM verdaccio/verdaccio:5
USER root
RUN yarn add verdaccio-ldap && yarn cache clean;
USER verdaccio