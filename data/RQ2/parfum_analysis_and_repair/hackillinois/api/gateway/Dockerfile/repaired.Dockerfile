FROM ubuntu:12.04

EXPOSE 8000

WORKDIR /opt/hackillinois/

ADD hackillinois-api-gateway /opt/hackillinois/

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN chmod +x hackillinois-api-gateway
RUN mkdir log/
RUN touch log/access.log

CMD ["./hackillinois-api-gateway", "-u"]
