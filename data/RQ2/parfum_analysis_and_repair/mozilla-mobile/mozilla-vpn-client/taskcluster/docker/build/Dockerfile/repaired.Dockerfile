FROM $DOCKER_IMAGE_PARENT

# Add external PPA, latest version of QT is 5.12.x for Ubuntu 20.04
RUN apt-get update && \
    apt-get install --no-install-recommends --yes golang debhelper rsync && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --find-links https://pypi.pub.build.mozilla.org/pub/ glean_parser==3.5

VOLUME /builds/worker/checkouts
VOLUME /builds/worker/.cache
