FROM quay.io/bioconda/bioconda-utils-build-env-cos7
# Retrieve index and set TTL to make it last over the duration of the test.
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda search bioconda-utils > /dev/null && \
    conda config --set local_repodata_ttl 3600 && \
    find /opt/conda \
      \! -group lucky \
      -exec chgrp --no-dereference lucky {} + \
      \! -type l \
      -exec chmod g=u {} +