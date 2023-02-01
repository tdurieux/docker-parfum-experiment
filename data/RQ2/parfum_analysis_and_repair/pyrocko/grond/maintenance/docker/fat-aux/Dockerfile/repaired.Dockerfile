FROM pyrocko-aux

# additional runtime requirements for gmt
RUN apt-get install --no-install-recommends -y \
        gmt gmt-gshhg poppler-utils imagemagick && rm -rf /var/lib/apt/lists/*;

COPY grond-test-data /grond-test-data
