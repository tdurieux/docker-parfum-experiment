# Run from the root project directory:
# docker build -t invertimo:v0 -f deployment/app/Dockerfile .
# To run on localhost (expects postgres running):
# docker run -d --net=host invertimo:v0
FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install pip tmux htop python3.8-venv curl && rm -rf /var/lib/apt/lists/*;

# Libpq is necessary for python PostgreSQL drivers.
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN python3.8 -m venv /usr/src/venv
RUN ls .
RUN /usr/src/venv/bin/pip3.8 install --no-cache-dir -r requirements.txt

RUN echo "Installing nodejs"
RUN curl -f -sL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;

COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build
CMD [ "./deployment/app/docker_entrypoint.sh" ]