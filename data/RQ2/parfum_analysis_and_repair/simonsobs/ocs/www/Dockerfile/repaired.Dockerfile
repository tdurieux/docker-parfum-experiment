# OCS Web Interface
# OCS base image with nginx installed and serving ocs/www

# Use ocs base image
FROM ocs:latest

# Install nginx
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Copy www directory into web path
COPY . /var/www/html

# Start up nginx within the container
CMD ["nginx", "-g", "daemon off;"]
