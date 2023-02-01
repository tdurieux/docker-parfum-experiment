FROM node:16

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/TundraBot
COPY . .
RUN npm install && npm cache clean --force;
RUN npm run build

# We need to do this to properly pass on shutdown signals
CMD ["node", "dist/TundraBot.js"]
# CMD ["npm", "run", "start"]