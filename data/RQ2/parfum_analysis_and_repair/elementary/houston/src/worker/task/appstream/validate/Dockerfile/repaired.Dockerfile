# Houston appdata docker file
# Builds an ubuntu base with appstreamcli for validating appstream files
#
# Version: 1.0.4

FROM elementary/docker:loki-stable

# Install liftoff
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

# ca-certificate stuff for removing glib-net error
RUN apt update && apt install --no-install-recommends -y appstream openssl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

# Execution
RUN mkdir -p /tmp/houston
WORKDIR /tmp/houston
ENTRYPOINT ["appstreamcli"]
