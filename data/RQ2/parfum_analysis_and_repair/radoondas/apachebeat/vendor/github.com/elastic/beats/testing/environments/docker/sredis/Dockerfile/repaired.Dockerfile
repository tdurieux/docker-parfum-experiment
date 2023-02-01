FROM debian:latest

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends stunnel4 -y && rm -rf /var/lib/apt/lists/*;

COPY stunnel.conf /etc/stunnel/stunnel.conf
COPY pki /etc/pki

EXPOSE 6380

CMD ["stunnel"]

