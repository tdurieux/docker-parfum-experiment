FROM canfar/astroml:latest

USER ${NB_UID}
COPY envs/tensorflow-gpu.yml /opt/image-build
RUN /opt/image-build/conda-install.sh /opt/image-build/tensorflow-gpu.yml