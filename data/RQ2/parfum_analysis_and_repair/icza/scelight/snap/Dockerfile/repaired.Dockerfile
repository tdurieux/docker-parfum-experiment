FROM ubuntu:18.04

# Update and install common dependencies.
RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential curl gosu sudo ruby snapcraft && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/snapbuild

# Set up the entry point script
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bash"]

