FROM nginx

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.test.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/ 