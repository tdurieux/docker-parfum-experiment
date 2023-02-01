FROM nginx
RUN apt update -y && apt upgrade -y
RUN apt install --no-install-recommends git npm -y && rm -rf /var/lib/apt/lists/*;
RUN npm -g install create-react-app && npm cache clean --force;
RUN create-react-app example
WORKDIR example
RUN npm install && npm cache clean --force;
RUN npm run build
RUN cp -r build/* /usr/share/nginx/html/
