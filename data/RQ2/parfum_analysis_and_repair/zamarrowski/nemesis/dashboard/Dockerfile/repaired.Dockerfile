FROM nginx
WORKDIR /usr/share/nginx/html
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN npm install && npm cache clean --force;
RUN npm run build
RUN cp -r ./build/* ./
RUN rm -rf node_modules/
RUN rm -rf src/
EXPOSE 80
