ARG BASEIMAGE=ontresearch/base-workflow-image:v0.1.0
FROM $BASEIMAGE
ARG ENVFILE=environment_generic.yaml
ARG NEXTCLADE_IMAGE_TAG

COPY $ENVFILE $HOME/environment.yaml
RUN \
    . $CONDA_DIR/etc/profile.d/mamba.sh \
    && micromamba activate \
    && micromamba install --file $HOME/environment.yaml \
    && micromamba install -c bioconda nextclade=$NEXTCLADE_IMAGE_TAG \
    && fix-permissions $CONDA_DIR \
    && fix-permissions $HOME

USER $WF_UID
WORKDIR $HOME
RUN nextclade dataset get --name 'sars-cov-2' --output-dir 'data/sars-cov-2'
ENV nextclade_data=$HOME/data/sars-cov-2