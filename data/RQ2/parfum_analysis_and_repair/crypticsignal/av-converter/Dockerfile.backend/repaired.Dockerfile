FROM node:16-alpine

COPY /backend .

# Install the dependencies in package.json
RUN yarn install && yarn cache clean;
# To download yt-dlp using curl
RUN apk --no-cache add curl
# Install yt-dlp
RUN curl -f -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp
# Python and FFmpeg are used by yt-dlp
RUN apk add --no-cache python3
RUN apk add  --no-cache ffmpeg

EXPOSE 9090

CMD ["node", "app.js"]