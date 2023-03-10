ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb https://deb.torproject.org/torproject.org focal main" >> /etc/apt/sources.list
RUN echo "deb-src https://deb.torproject.org/torproject.org focal main" >> /etc/apt/sources.list

COPY tor.pgp.pub tor.pgp.pub
RUN gpg --batch --import tor.pgp.pub
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN gpg --batch --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tor deb.torproject.org-keyring && rm -rf /var/lib/apt/lists/*;

# SOCKS5, Control Port, DNS
EXPOSE 9050 9051 9053


COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# ARG BASE_IMAGE
# FROM ${BASE_IMAGE}

# ENV DEBIAN_FRONTEND=noninteractive
# # TODO implement method https://2019.www.torproject.org/docs/debian.html.en to
# # to apt as tor.
# RUN echo "deb https://mirror.netcologne.de/mirror.netcologne.de bionic main" >> /etc/apt/sources.list
# RUN echo "deb-src https://mirror.netcologne.de/mirror.netcologne.de bionic main" >> /etc/apt/sources.list

# COPY TOR-project-PGP.pub TOR-project-PGP.pub
# RUN gpg --import TOR-project-PGP.pub
# RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# RUN apt-get update && apt-get install -y tor tor-geoipdb torsocks deb.torproject.org-keyring
# #deb.torproject.org-keyring

# # SOCKS5, Control Port, DNS
# EXPOSE 9050 9051 9053


# COPY entrypoint.sh /entrypoint.sh
# RUN chmod 0755 /entrypoint.sh

# ENTRYPOINT [ "/entrypoint.sh" ]











# ARG BASE_IMAGE

# FROM ${BASE_IMAGE}

# #ENV DEBIAN_FRONTEND=noninteractive
# # TODO implement method https://2019.www.torproject.org/docs/debian.html.en to
# # to apt as tor.
# RUN echo "deb https://deb.torproject.org/torproject.org bionic main" >> /etc/apt/sources.list
# RUN echo "deb-src https://deb.torproject.org/torproject.org bionic main" >> /etc/apt/sources.list

# RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
# RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# RUN apt-get update
# RUN apt-get install -y tor deb.torproject.org-keyring

# # SOCKS5, Control Port, DNS
# EXPOSE 9050 9051 9053


# COPY entrypoint.sh /entrypoint.sh
# RUN chmod 0755 /entrypoint.sh

# ENTRYPOINT [ "/entrypoint.sh" ]

