FROM node  AS builder
WORKDIR "/app"
COPY . .

# Install 7z for packaging

RUN apt-get update
RUN apt-get install --no-install-recommends p7zip-full -y && rm -rf /var/lib/apt/lists/*;

# Update bin-path for docker/linux

RUN echo 'ffmpeg: "./bin/ffmpeg/ffmpeg"\nmkvmerge: "./bin/mkvtoolnix/mkvmerge"' > /app/config/bin-path.yml

#Build AniDL

RUN npm i && npm cache clean --force;
RUN npm run build-ubuntu-cli

# Move build to new Clean Image

FROM node
WORKDIR "/app"
COPY --from=builder /app/lib/_builds/multi-downloader-nx-ubuntu64-cli ./

# Install mkvmerge and ffmpeg

RUN mkdir -p /app/bin/mkvtoolnix
RUN mkdir -p /app/bin/ffmpeg

RUN apt-get update
RUN apt-get install --no-install-recommends mkvtoolnix -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

RUN mv /usr/bin/mkvmerge /app/bin/mkvtoolnix/mkvmerge
RUN mv /usr/bin/ffmpeg /app/bin/ffmpeg/ffmpeg

ENTRYPOINT ["tail", "-f", "/dev/null"]