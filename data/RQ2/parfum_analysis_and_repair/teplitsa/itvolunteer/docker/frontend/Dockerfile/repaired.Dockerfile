FROM node:carbon

WORKDIR /site/tep-itv/wp-content/themes/tstsite/src_spa/
RUN npm install && npm cache clean --force;
ENV PATH /site/tep-itv/wp-content/themes/tstsite/src_spa/node_modules/.bin:$PATH
