FROM ghcr.io/hyperledger/iroha:1.3.0
WORKDIR /opt/iroha_data
ENTRYPOINT [""]
COPY run-iroha.sh wait-for-it.sh /
RUN chmod +x /run-iroha.sh; \
    chmod +x /wait-for-it.sh; \
    apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

CMD ["/run-iroha.sh"]
