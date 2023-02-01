FROM build-base

# This silences a transifex-client warning
RUN apt-get install --no-install-recommends -qqy git && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir transifex-client lxml babel

USER builder
COPY --chown=builder transifexrc /home/builder/.transifexrc
