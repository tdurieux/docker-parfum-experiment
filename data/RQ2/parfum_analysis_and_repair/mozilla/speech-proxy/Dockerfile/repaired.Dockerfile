FROM node:12-slim

# add a non-privileged user for installing and running
# the application
RUN groupadd --gid 10001 app && \
    useradd --uid 10001 --gid 10001 --home /app --create-home app

# Install updates & firejail
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      yasm libvpx-dev libgmp-dev git python build-essential opus-tools && \
    git clone https://github.com/FFmpeg/FFmpeg /app/ffmpeg && \
    cd /app/ffmpeg && git checkout release/3.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libvpx && make && make install && \
    rm -rf /app/ffmpeg && \
    apt remove -y libgmp-dev git python build-essential && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json

# Install node requirements
RUN npm install && npm cache clean --force

COPY . /app

USER app

CMD ["node", "server.js"]
