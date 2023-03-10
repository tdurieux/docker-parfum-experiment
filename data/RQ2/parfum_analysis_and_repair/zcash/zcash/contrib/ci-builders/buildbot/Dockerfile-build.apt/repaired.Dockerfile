ARG FROMBASEOS
ARG FROMBASEOS_BUILD_TAG
FROM $FROMBASEOS:$FROMBASEOS_BUILD_TAG
ARG DEBIAN_FRONTEND=noninteractive

ADD apt-package-list.txt /tmp/apt-package-list.txt
RUN apt-get update \
    && apt-get install --no-install-recommends -y $(tr "\n" " " < /tmp/apt-package-list.txt) \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && rm -rf /var/lib/apt/lists/*;
