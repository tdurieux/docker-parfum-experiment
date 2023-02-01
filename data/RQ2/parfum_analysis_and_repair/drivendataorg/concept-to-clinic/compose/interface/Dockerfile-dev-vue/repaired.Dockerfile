FROM node:8-slim

# Install Selenium dependencies
RUN apt-get update && apt-get install --no-install-recommends -y bzip2 git && rm -rf /var/lib/apt/lists/*;

# Install Node dependencies
COPY ./interface/frontend /app
RUN cd /app && npm install && npm cache clean --force;

EXPOSE 8080

WORKDIR /app

CMD [ "npm", "run" "dev" ]
