# -------------------------
#       Development
# -------------------------
FROM node:12 as development

ENV APP_FOLDER="/usr/src/app"

WORKDIR ${APP_FOLDER}
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install && npm cache clean --force;
COPY . ${APP_FOLDER}

CMD ["npm", "start"]



# -------------------------
#         Builder
# -------------------------
FROM development as builder
RUN npm i -g @zeit/ncc && npm cache clean --force;
CMD ["npm", "run", "build"]