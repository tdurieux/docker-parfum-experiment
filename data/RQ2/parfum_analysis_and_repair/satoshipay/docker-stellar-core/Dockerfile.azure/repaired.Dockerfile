ARG TAG
FROM satoshipay/stellar-core:$TAG

ENV AZURE_STORAGE_AUTH_MODE=key

ADD install.azure.sh /
RUN /install.azure.sh