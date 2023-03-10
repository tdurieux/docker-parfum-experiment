FROM pollendina/client-debian:jessie

# Copy Certificate Authority certificate to /certs
COPY cacert.pem /certs/cacert.pem

# Certificate parameters
ENV COMMON_NAME=dario COUNTRY=US STATE=California CITY=SF ORGANIZATION=Marriot COMMON_NAME=Room_Controller

RUN apt-get update && apt-get install --no-install-recommends -y \
	curl nginx && rm -rf /var/lib/apt/lists/*;

COPY html/*  /usr/share/nginx/html/
COPY ssl.conf /etc/nginx/conf.d/ssl.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
