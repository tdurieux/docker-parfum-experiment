FROM minio/minio:RELEASE.2022-05-26T05-48-41Z.hotfix.15f13935a

ARG USER_ID=1000

USER root

RUN groupadd -g ${USER_ID} kminio \
    && useradd -m -s /bin/bash -g ${USER_ID} -u ${USER_ID} -G root kminio \
    && mkdir /data || true \
    && chown root:root /data \
    && chmod u+rwx /data \
    && chmod g+rwx /opt

USER kminio

RUN umask u=rwx,g=rwx,o=rx