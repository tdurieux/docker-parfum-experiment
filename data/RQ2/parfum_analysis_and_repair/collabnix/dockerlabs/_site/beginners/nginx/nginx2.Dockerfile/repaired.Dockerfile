# Nginx
#
# VERSION               0.0.1
# Applying LABEL

FROM      ubuntu
LABEL Description="This image is used to start the foobar executable" Vendor="Collabnix Products" Version="1.0"
RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools nginx apache2 openssh-server && rm -rf /var/lib/apt/lists/*;
