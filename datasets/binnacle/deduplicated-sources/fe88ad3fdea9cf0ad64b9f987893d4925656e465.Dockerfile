FROM alpine:3.3  
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>  
  
RUN apk add --no-cache --virtual .run-deps git  
  
ENTRYPOINT ["git"]  

