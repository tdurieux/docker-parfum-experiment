FROM scratch

COPY minio /minio

CMD ["/minio"]