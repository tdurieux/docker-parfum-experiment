FROM node:12

COPY dist ./dist

RUN npm install -g serve && npm cache clean --force;
ENV PORT=80
CMD serve -s dist -p 80
