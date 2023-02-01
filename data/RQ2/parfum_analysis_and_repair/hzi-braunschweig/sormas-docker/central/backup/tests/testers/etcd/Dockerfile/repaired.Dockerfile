FROM quay.io/coreos/etcd:v3.5.0

RUN apt update && apt install --no-install-recommends -y bash openssl && rm -rf /var/lib/apt/lists/*;

COPY res /res
RUN chmod a+x /res/*.sh
ENTRYPOINT ["/res/entrypoint.sh"]
CMD []
