FROM nginx:stable-alpine
COPY public/maintenance.html /usr/share/nginx/html/index.html
COPY public/maintenance-illustration.svg /usr/share/nginx/html/
COPY public/favicon.ico /usr/share/nginx/html/