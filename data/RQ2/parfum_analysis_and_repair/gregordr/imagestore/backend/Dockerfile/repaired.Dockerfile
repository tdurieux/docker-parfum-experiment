FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install --no-install-recommends ffmpeg python3 ca-certificates curl make g++ -y && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates --fresh
WORKDIR /code
EXPOSE 4000
COPY package*.json ./
RUN npm i && npm cache clean --force;
COPY . .
VOLUME /code/media
ENV IMAGESTORE_HOST 0.0.0.0
CMD "npm" "start"
