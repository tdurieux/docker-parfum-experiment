FROM alpine:3.15.4 

WORKDIR /app 
COPY ./fetcher.sh /app/fetcher.sh
RUN chmod +x /app/fetcher.sh 
ENTRYPOINT [ "/app/fetcher.sh" ]