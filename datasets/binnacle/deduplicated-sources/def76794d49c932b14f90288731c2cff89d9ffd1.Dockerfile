FROM botfactory/docker-for-terremotibot:8.16.0

LABEL mantainer="Matteo Contrini <matteo@contrini.it>"

# Move to /src
WORKDIR /src

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the app files
COPY . .

# Expose ports to host
EXPOSE 5000

# Start
CMD ["npm", "run", "dev"]
