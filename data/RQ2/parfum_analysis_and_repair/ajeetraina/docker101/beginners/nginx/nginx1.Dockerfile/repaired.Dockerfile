# Nginx
#
# VERSION               0.0.1

# Demonstrating a simple Nginx Application

FROM      ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools nginx apache2 openssh-server && rm -rf /var/lib/apt/lists/*;
