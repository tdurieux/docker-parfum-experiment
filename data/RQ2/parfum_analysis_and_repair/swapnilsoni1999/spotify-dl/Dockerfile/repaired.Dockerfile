FROM buildkite/puppeteer

RUN apt update && \
    apt install --no-install-recommends -y \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g spotify-dl --unsafe-perm && npm cache clean --force;

## uncomment this for local testing
# COPY ./ /usr/local/lib/node_modules/spotify-dl/
WORKDIR /download
ENTRYPOINT ["spotifydl"]
CMD ["--help"]
