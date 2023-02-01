ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ARG VERSION
ENV PYTHON_VERSION=${VERSION}

RUN apt-get update \
  && apt-get install --no-install-recommends -y gosu gcc build-essential python-dev libxml2 libxml2-dev zlib1g-dev \
  && apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /sebs/
COPY docker/python_installer.sh /sebs/installer.sh
COPY docker/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh

# useradd and groupmod is installed in /usr/sbin which is not in PATH
ENV SCRIPT_FILE=/mnt/function/package.sh
CMD /bin/bash /sebs/installer.sh
ENTRYPOINT ["/sebs/entrypoint.sh"]
