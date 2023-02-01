FROM node
RUN useradd ctf
COPY ./index.js /opt/
COPY ./package.json /opt/
WORKDIR /opt/
RUN npm install && npm cache clean --force;
USER ctf
CMD ["node","index.js"]
