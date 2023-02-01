# Origin image
FROM debian

# update
RUN apt update && apt install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*; # Setup Server Environment


# Setup the vulnerability environment
RUN rm /var/www/html/index.html
COPY files /var/www/html/

# Entry point
ENTRYPOINT service apache2 start
