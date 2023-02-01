#Dockerised version of p5 Manager
#https://github.com/chiunhau/p5-manager

FROM node
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN npm install -g p5-manager && npm cache clean --force;

# Setup:
# docker build -t p5manager .

# map ports for server and live-reload
#also mount the current directory to /app inside the container
# docker run -it -p 5555:5555 -p 35729:35729 -v"$(PWD)":/app p5manager bash

# Once inside the container...
# cd /app/my_collection/ && p5 s
