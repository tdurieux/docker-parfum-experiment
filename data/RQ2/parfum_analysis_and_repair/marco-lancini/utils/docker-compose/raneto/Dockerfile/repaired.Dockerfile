FROM node

RUN apt update && apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/gilbitron/Raneto.git /wiki/

WORKDIR /wiki/
RUN npm install && npm run gulp && npm cache clean --force;

EXPOSE 3000
CMD [ "npm", "start" ]
