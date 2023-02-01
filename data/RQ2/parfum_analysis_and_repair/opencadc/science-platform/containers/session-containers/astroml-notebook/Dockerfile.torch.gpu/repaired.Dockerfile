FROM canfar/astroml:latest

USER ${NB_UID}

COPY envs/pytorch-gpu.yml /opt/image-build
RUN /opt/image-build/conda-install.sh /opt/image-build/pytorch-gpu.yml