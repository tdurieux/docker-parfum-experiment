# Usage: FROM [image name]
FROM ubuntu

MAINTAINER Adithya Khamithkar <nkadithya31@gmail.com>

# Initialize
RUN apt-get update && apt-get install --no-install-recommends -y net-tools vim && rm -rf /var/lib/apt/lists/*;

# Install nginx
#RUN apt-get install -y nginx

# Open ports
EXPOSE 80

# Start nginx
