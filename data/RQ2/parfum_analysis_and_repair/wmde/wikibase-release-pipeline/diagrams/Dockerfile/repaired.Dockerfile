FROM node:14

RUN apt-get update && apt-get install --no-install-recommends -y libnss3 libatk-bridge2.0 libx11-xcb1 libdrm2 libxkbcommon0 libgtk-3-0 libasound2 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
