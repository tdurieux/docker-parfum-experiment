FROM scratch
COPY testfile renamedfile
FROM scratch
COPY --chown=1:1 --from=0 renamedfile /