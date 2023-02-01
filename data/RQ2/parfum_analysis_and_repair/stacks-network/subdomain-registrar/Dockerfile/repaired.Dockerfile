FROM node:12


# Update apt and install wget
RUN apt-get update && apt-get install --no-install-recommends -y wget curl sqlite3 && rm -rf /var/lib/apt/lists/*;

# Project directory
WORKDIR /src/subdomain-registrar
# Copy files into container
COPY . .

RUN npm i && npm cache clean --force;
RUN npm run build

CMD node lib/index.js
