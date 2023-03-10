FROM --platform=$BUILDPLATFORM python:2


WORKDIR /app
ADD n9e /app
ADD http://download.flashcat.cloud/wait /wait
RUN mkdir -p /app/pub && chmod +x /wait
ADD pub /app/pub/
RUN chmod +x n9e

EXPOSE 19000
EXPOSE 18000

CMD ["/app/n9e", "-h"]