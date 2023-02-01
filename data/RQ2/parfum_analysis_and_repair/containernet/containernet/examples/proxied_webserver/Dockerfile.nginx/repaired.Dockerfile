FROM nginx

# Install dependencies required for Containernet.
RUN apt-get update && apt-get install --no-install-recommends -y \
    net-tools \
    iputils-ping \
    iproute2 && rm -rf /var/lib/apt/lists/*;

COPY nginx.conf /etc/nginx/nginx.conf
