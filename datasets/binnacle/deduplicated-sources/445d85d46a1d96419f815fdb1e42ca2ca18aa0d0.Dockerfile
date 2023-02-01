# This act requires puppeteer and node 8
FROM apify/actor-node-puppeteer

# Tell Node.js this is a production environemnt
ENV NODE_ENV=production

# Copy all files and directories from the directory to the Docker image
COPY . ./

# Install NPM packages, skip optional and development dependencies to keep the image small,
# avoid logging to much and show log the dependency tree
RUN npm install --quiet --only=prod \
 && npm list

# Define that start command
CMD [ "node", "build/index.js" ]
