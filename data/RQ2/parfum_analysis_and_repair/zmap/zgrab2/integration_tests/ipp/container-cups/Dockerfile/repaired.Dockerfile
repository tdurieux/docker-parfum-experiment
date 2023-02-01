FROM zgrab2_service_base:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
  cups \
  cups-pdf && rm -rf /var/lib/apt/lists/*;
WORKDIR /etc/cups
COPY cupsd.conf cupsd.conf

RUN service cups stop
RUN update-rc.d -f cupsd remove

WORKDIR /
COPY entrypoint.sh .
RUN chmod a+x ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]