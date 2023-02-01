# not slim because we need github depedencies
FROM node:12.16-buster

# ffmpeg 4+ is required
RUN apt update && apt install --no-install-recommends -y ffmpeg=*:4.** && rm -rf /var/lib/apt/lists/*;
# Create app directory
WORKDIR /app

# to make use of caching, copy only package files and install dependencies
COPY package*.json /app/
#RUN  npm ci --verbose  # we should make lockfile or shrinkwrap then use npm ci for predicatble builds
RUN npm install --no-progress --verbose && npm cache clean --force;

# copy then compile the code
COPY . .
RUN npm run compile

ENV NODE_ENV=production
ENV PORT=3030
ENV MYSQL_URL=

EXPOSE 3030
CMD [ "node", "lib/index.js" ]
