FROM alpine:latest  
  
RUN apk --update add \  
bash \  
jq \  
py-pip \  
python \  
curl \  
zip && \  
pip install awscli && \  
apk --purge del py-pip && \  
rm var/cache/apk/*  
  
COPY scripts/ /usr/local/bin/  

