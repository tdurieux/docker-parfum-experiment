FROM cypress/included:7.6.0

COPY ./spec/cypress/support /cypress/support
# install the needed support stuff
RUN cd /cypress/support && yarn install && yarn cache clean;
