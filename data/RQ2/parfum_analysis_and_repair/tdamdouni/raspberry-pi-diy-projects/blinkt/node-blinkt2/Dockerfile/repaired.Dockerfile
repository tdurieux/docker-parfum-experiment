FROM hypriot/rpi-node
COPY . .
RUN npm install && npm cache clean --force;
CMD [ "node", "example" ]