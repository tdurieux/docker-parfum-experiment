FROM ibmcom/ibm-application-gateway:20.01
LABEL maintainer="nlloyd@us.ibm.com" vendor="ISAML2"

COPY config/l2dashboard.yml /var/iag/config/
COPY iag.pem /var/iag/config/
COPY oct-512-bit.bin /var/iag/config/
