FROM node

RUN apt update && apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/petercunha/Pad.git /pad/

WORKDIR /pad/
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD [ "npm", "start" ]
