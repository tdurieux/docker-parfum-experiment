FROM @REPOSITORY@/eunomia-base:@IMAGE_TAG@

USER root

RUN pip3 install --no-cache-dir j2cli[yaml]

COPY bin/processTemplates.sh /usr/local/bin/processTemplates.sh

USER ${USER_UID}
