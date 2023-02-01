FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y shellcheck && rm -rf /var/lib/apt/lists/*;

COPY . /opt/debian-cis/

COPY debian/default /etc/default/cis-hardening
RUN sed -i 's#cis-hardening#debian-cis#' /etc/default/cis-hardening

WORKDIR /opt/debian-cis

ENTRYPOINT ["/opt/debian-cis/shellcheck/launch_shellcheck.sh"]

