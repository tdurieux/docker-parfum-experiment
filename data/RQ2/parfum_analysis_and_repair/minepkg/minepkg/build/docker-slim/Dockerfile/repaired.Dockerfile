FROM ubuntu:latest

# install ca certificates
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && update-ca-certificates && rm -rf /var/lib/apt/lists/*;

# add minepkg
ADD https://storage.googleapis.com/minepkg-client/latest/minepkg-linux-amd64 /usr/bin/minepkg
RUN chmod +rx /usr/bin/minepkg

# set it as cmd
CMD ["/usr/bin/minepkg"]
