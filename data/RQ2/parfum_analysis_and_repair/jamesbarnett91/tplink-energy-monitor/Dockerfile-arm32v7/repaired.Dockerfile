FROM arm32v7/node:8.11-slim
WORKDIR /opt/tplink-monitor
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]
