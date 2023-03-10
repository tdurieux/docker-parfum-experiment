FROM node:12-alpine
WORKDIR /app
COPY . .
COPY config.json_dist config/config.json
RUN npm install --production && npm cache clean --force;
RUN npm install -g @vercel/ncc && npm cache clean --force;
RUN ncc build index.js -o dist
RUN rm -rf node_modules
CMD ["node", "dist/index.js"]

EXPOSE 18542/udp
