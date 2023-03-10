FROM haproxy:1.8
LABEL maintainer="nlloyd@us.ibm.com" vendor="ISAML2"

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY frontend.pem /usr/local/lib/frontend.pem
COPY ca-cert.pem /usr/local/lib/ca-cert.pem
COPY 502.html /usr/local/etc/haproxy/errors/502.html