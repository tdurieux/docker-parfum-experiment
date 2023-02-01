FROM nginx
RUN apt update -y && apt upgrade -y
RUN apt install --no-install-recommends git npm -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/programandoconro/MyReactTODOApp
WORKDIR MyReactTODOApp
RUN npm install && npm run build && npm cache clean --force;
RUN cp -r build/* /usr/share/nginx/html/
