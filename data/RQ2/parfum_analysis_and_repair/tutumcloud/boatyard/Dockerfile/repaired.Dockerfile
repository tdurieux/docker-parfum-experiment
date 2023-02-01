FROM tutum/buildstep
MAINTAINER info@tutum.co

# Install nginx and supervisor
RUN apt-get update && apt-get install --no-install-recommends -y nginx supervisor && rm -rf /var/lib/apt/lists/*;

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/*
ADD nginx.conf /etc/nginx/sites-enabled/builder.conf

# Configure supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord-builder.conf

# nginx will bind to port 80, exposing both web UI and API
EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
