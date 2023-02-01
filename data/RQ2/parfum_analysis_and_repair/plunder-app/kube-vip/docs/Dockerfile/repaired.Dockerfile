FROM nginx:latest
RUN apt-get update; apt-get install --no-install-recommends -y nodejs npm; rm -rf /var/lib/apt/lists/*; npm install -g markdown-styles; npm cache clean --force;
COPY . /docs
WORKDIR /docs
RUN generate-md --layout github --input ./ --output /usr/share/nginx/html/
