ARG BASEIMAGE=ontresearch/base-workflow-image:v0.1.0
FROM $BASEIMAGE
ARG ENVFILE=environment_generic.yaml
ARG PANGOLIN_IMAGE_TAG

COPY $ENVFILE $HOME/environment.yaml
RUN \
    . $CONDA_DIR/etc/profile.d/mamba.sh \
    && micromamba activate \
    && micromamba install --file $HOME/environment.yaml \
    && micromamba install -c bioconda -c defaults -c conda-forge pangolin=$PANGOLIN_IMAGE_TAG \
    && fix-permissions $CONDA_DIR \
    && fix-permissions $HOME

RUN pangolin --update

USER $WF_UID
WORKDIR $HOME