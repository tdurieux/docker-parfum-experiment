# https://github.com/stilliard/docker-pure-ftpd
FROM stilliard/pure-ftpd
# Create user and directory for anonymous access.
RUN useradd -d /var/ftp -u 2001 -s /sbin/nologin ftp
RUN mkdir /var/ftp
# Run the server