FROM datajoint/pydev

COPY --chown=dja . /tmp/src
RUN pip install --no-cache-dir --user /tmp/src && \
    rm -rf /tmp/src
