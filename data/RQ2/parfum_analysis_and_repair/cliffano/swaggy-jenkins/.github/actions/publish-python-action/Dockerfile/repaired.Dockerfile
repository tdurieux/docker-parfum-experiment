FROM cliffano/studio
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh", "$PYPI_TOKEN"]