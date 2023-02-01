## aws-signing-proxy
FROM scratch
MAINTAINER Chris Lunsford <cllunsford@gmail.com>

# Add ca-certificates.crt for https
ADD ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Add executable
ADD aws-signing-proxy /

# Default listening port