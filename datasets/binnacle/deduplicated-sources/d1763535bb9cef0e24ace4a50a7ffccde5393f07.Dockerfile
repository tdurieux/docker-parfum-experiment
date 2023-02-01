# Docker file for JuliaBox Engine Daemon
# Version:1

FROM juliabox/enginebase

MAINTAINER Tanmay Mohapatra

# Expose the daemon ports.
# For proxying to work efficiently, it may be best to run the container on host network stack
EXPOSE 8889 8890

# mount host /proc to get control of all processes
VOLUME /hostproc

# let juser mount volumes in other namespaces
RUN pip install nsenter
#RUN git clone https://github.com/tanmaykm/python-nsenter.git \
#    && cd python-nsenter \
#    && git checkout procarg \
#    && python setup.py install \
#    && cd .. \
#    && rm -rf python-nsenter

RUN echo "juser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Provide env with command prefix required to access host mnt namespace
ENV HOST_MNT_PFX="nsenter --target 1 --proc /hostproc --mnt --" \
    CONT_MNT_PFX="nsenter --target {{CPID}} --proc /hostproc --mnt --" \
    HOST_IPC_PFX="nsenter --target 1 --proc /hostproc --ipc --"

USER juser
ENV LANG en_US.utf8

ENTRYPOINT ["/jboxengine/src/jboxd.py"]