FROM nginx:1.17-alpine

# If this fails, you ended up using a base image with bash installed. Consider removing /bin/bash in this case
RUN if bash -c true &> /dev/null; then exit 1; fi

# Make sure the nc check fails in this container
RUN rm /usr/bin/nc

ADD nginx.conf /etc/nginx/conf.d/default.conf