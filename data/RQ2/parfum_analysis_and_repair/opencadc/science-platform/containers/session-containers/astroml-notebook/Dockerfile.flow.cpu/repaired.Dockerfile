FROM canfar/astroml:latest

USER ${NB_UID}
COPY envs/tensorflow-cpu.yml /opt/image-build
RUN /opt/image-build/conda-install.sh /opt/image-build/tensorflow-cpu.yml