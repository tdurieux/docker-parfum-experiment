FROM zgrab2_service_base:latest

RUN apt-get install --no-install-recommends -y qpsmtpd && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY entrypoint.sh .
RUN chmod a+x ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
