FROM ubuntu

#RUN sudo apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD main /main
ADD entrypoint.sh /entrypoint.sh
ADD static /static
ADD data /data
WORKDIR /

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]

