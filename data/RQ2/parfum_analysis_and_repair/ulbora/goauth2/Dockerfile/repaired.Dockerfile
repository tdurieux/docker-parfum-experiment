FROM ubuntu

#RUN sudo apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
ADD main /main
ADD start.sh /start.sh
ADD entrypoint.sh /entrypoint.sh
ADD static /static
WORKDIR /

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]

