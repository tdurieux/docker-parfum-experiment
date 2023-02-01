FROM nginx:alpine

# Copy in nginx config
COPY nginx/default.conf /etc/nginx/conf.d/

# Copy in the built Angular app
COPY dist/hydrus-web /usr/share/nginx/html