FROM node:8
WORKDIR "/app"
ADD . /app
RUN npm install && npm cache clean --force;
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
EXPOSE 8000
CMD ["npm", "start"]
