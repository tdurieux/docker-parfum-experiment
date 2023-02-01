FROM ubuntu:latest

# Set the file maintainer (your name - the file's author)
MAINTAINER Ray Alez

# Install Nginx.	
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Turn off daemon mode
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Copy nginx config
COPY nginx_proxy.conf /etc/nginx/sites-enabled/default

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80



