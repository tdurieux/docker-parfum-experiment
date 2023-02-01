FROM ubuntu:18.04

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install fence-agents gnutls-bin curl ipmitool && rm -rf /var/lib/apt/lists/*;
