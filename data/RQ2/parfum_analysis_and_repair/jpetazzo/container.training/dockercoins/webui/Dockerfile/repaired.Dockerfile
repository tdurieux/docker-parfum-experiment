FROM node:4-slim
RUN npm install express && npm cache clean --force;
RUN npm install redis@3 && npm cache clean --force;
COPY files/ /files/
COPY webui.js /
CMD ["node", "webui.js"]
EXPOSE 80
