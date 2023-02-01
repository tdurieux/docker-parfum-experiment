FROM node

RUN apt update && apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/cracker0dks/whiteboard.git /whiteboard/

WORKDIR /whiteboard/
RUN npm install && npm cache clean --force;

EXPOSE 8080
CMD [ "npm", "start" ]
