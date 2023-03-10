FROM certs:latest as certs
FROM vault:1.10.0

COPY spec/acceptance/fixtures/vault_config.hcl /vault/config/vault_config.hcl


COPY --from=certs /root/ca/intermediate/crl/crlchain.pem /vault/config/crlchain.pem
COPY --from=certs /root/ca/intermediate/private/vault.key.pem /vault/config/vault.key
COPY --from=certs /root/ca/intermediate/certs/vault.cert.pem /vault/config/vault.cert
COPY --from=certs /root/ca/intermediate/certs/ca-bundle.cert.pem /vault/config/certbundle.pem

RUN chown -R vault:vault /vault

CMD ["server"]