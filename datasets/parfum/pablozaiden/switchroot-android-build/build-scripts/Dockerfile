FROM pablozaiden/switchroot-android-build:base-latest

#by default, build icosa
ENV ROM_NAME "icosa_sr"
#by default, build zip
ENV ROM_TYPE "zip"

#preserve cache in next to the code to improve build times
ENV CCACHE_DIR "${BUILDBASE}/android/.ccache"

ENV EXTRA_CONTENT "${BUILDBASE}/extra-content"

USER build
WORKDIR ${BUILDBASE}

ADD --chown=build:build ./default-command.sh ${BUILDBASE}/default-command.sh
ADD --chown=build:build ./get-sources.sh ${BUILDBASE}/get-sources.sh
ADD --chown=build:build ./build.sh ${BUILDBASE}/build.sh
ADD --chown=build:build ./copy-to-output.sh ${BUILDBASE}/copy-to-output.sh

RUN chmod +x ./*.sh

CMD ${BUILDBASE}/default-command.sh