ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install --no-install-recommends -y gosu && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /sebs/
COPY docker/nodejs_installer.sh /sebs/installer.sh
COPY docker/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh

# useradd and groupmod is installed in /usr/sbin which is not in PATH
ENV PATH=/usr/sbin:$PATH
ENV SCRIPT_FILE=/mnt/function/package.sh
CMD /bin/bash /sebs/installer.sh
ENTRYPOINT ["/sebs/entrypoint.sh"]
