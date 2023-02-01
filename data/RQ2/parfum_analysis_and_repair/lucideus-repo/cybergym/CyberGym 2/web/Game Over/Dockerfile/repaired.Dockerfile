# Origin image
FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;

# Setup the vulnerability environment
COPY bg.jpg  /var/www/html/
COPY index.html /var/www/html/

# Entry point
ENTRYPOINT service apache2 start && /bin/bash
