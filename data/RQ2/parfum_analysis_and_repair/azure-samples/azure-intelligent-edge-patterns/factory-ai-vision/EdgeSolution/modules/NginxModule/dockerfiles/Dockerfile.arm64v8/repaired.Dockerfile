FROM arm64v8/nginx

# RUN rm /etc/nginx/conf.d/*
COPY ./conf.d/default.conf /etc/nginx/conf.d/default.conf
# COPY ./ssl /usr/share/nginx/ssl/

EXPOSE 8000
EXPOSE 8181