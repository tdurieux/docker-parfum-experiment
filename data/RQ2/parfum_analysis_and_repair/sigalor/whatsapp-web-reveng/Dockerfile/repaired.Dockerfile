FROM node

# Install pip
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-pip && rm -rf /var/lib/apt/lists/*;


# Create app dir
RUN mkdir /app
WORKDIR /app

# COPY project in app dir
COPY . .

# Install dependencies
## JS Dep
### Using Yarn
#RUN yarn
#RUN yarn global add concurrently
### Using NPM
RUN npm install && npm cache clean --force;
RUN npm install -g concurrently && npm cache clean --force;

# Pip requirements
RUN pip install --no-cache-dir -r requirements.txt


# Command
## Yarn
#CMD yarn __run_in_docker
CMD npm run __run_in_docker
