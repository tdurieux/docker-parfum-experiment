FROM quay.io/coreos/clair:v2.0.3  
COPY config.yaml /config/config.yaml  
  
CMD ["-config=/config/config.yaml"]  

