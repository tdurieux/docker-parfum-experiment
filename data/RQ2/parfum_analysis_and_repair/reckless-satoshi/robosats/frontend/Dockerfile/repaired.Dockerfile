FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/src/frontend && rm -rf /usr/src/frontend

# specifying the working dir inside the container
WORKDIR /usr/src/frontend

# copy current dir's content to container's WORKDIR root i.e. all the contents of the robosats app
COPY . .

RUN apt-get update && apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;

# packages we use

RUN npm install && npm cache clean --force;

# launch

CMD ["npm", "run", "build"]