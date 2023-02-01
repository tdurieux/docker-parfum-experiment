FROM hexletbasics/base-image

WORKDIR /exercises-html

RUN npm i -g htmlhint && npm cache clean --force;
RUN npm i -g jsdom jsdom-global && npm cache clean --force;
RUN npm i -g chai chai-dom && npm cache clean --force;
RUN npm i -g @testing-library/dom && npm cache clean --force;
RUN npm i -g @github/query-selector && npm cache clean --force;

COPY . .

ENV NODE_PATH /usr/lib/node_modules:/exercises-html/src
