FROM scratch
COPY testfile renamedfile
FROM scratch
COPY --chown=2:2 --from=0 renamedfile /