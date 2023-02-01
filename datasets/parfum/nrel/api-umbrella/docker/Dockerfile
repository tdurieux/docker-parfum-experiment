FROM debian:stretch

ENV API_UMBRELLA_VERSION 0.15.1-1~stretch

# Install API Umbrella
RUN echo "deb http://dl.bintray.com/nrel/api-umbrella-debian stretch main" >> /etc/apt/sources.list.d/api-umbrella.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends --allow-unauthenticated install api-umbrella

# Define mountable directories
VOLUME ["/etc/api-umbrella", "/opt/api-umbrella/var/db", "/opt/api-umbrella/var/log"]

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Run the API Umbrella service
CMD ["api-umbrella", "run"]
