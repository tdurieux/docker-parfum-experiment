# miTLS build container

# Define on fstar-version.json what FStar base container image
# mitls build should use.
# By default it always look for the latest FStar container available
# In case you would like to reference a specific commit,
# replace latest with the commit id from github using 12 characters.
ARG DOCKERHUBPROJECT
ARG COMMITID
FROM ${DOCKERHUBPROJECT}fstar-linux:${COMMITID}

ARG BUILDLOGFILE
ARG MAXTHREADS
ARG BUILDTARGET
ARG BRANCHNAME

# ADD SSH KEY
RUN mkdir -p ${MYHOME}/.ssh
RUN chown everest ${MYHOME}/.ssh
RUN chmod 700 ${MYHOME}/.ssh
COPY --chown=everest id_rsa ${MYHOME}/.ssh/id_rsa
RUN chmod 600 ${MYHOME}/.ssh/id_rsa

# Copy source files
RUN mkdir ${MYHOME}/mitls-fstar
COPY --chown=everest / ${MYHOME}/mitls-fstar/

# Do some cleanup
RUN rm -f build.sh
RUN rm -f build_helper.sh
RUN rm -f buildlogfile.txt
RUN rm -f log_no_replay.html
RUN rm -f log_worst.html
RUN rm -f orange_status.txt
RUN rm -f result.txt
RUN rm -f status.txt
RUN rm -f commitinfofilename.json

RUN rm mitls-fstar/Dockerfile
RUN rm mitls-fstar/build.sh
RUN rm mitls-fstar/build_helper.sh
RUN rm mitls-fstar/id_rsa
RUN rm mitls-fstar/commitinfofilename.json

COPY --chown=everest build.sh ${MYHOME}/build.sh
RUN chmod +x build.sh
COPY --chown=everest build_helper.sh ${MYHOME}/build_helper.sh
RUN chmod +x build_helper.sh

RUN ./build_helper.sh ${BUILDTARGET} ${BUILDLOGFILE} ${MAXTHREADS} ${BRANCHNAME} || true

# Remove ssh identities.
RUN rm ${MYHOME}/.ssh/id_rsa
