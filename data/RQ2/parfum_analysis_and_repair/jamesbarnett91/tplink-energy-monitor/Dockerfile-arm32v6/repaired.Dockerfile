FROM hypriot/rpi-node:8.1-slim
WORKDIR /opt/tplink-monitor
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]
