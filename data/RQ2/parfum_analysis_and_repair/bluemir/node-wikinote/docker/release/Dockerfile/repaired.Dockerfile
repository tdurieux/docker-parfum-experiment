FROM node:6
RUN npm install -g wikinote && npm cache clean --force;
ENTRYPOINT ["wikinote", "-p", "4000"]
