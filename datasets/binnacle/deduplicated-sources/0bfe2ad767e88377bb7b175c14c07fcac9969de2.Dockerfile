FROM alpine:3.4  
RUN apk update && apk add jq  
ENTRYPOINT ["jq"]  
CMD ["-h"]  

