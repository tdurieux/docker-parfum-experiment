FROM cbonamy/sedfoam_v2106_ubuntu
LABEL maintainer "cyrille.bonamy@univ-grenoble-alpes.fr"
ARG WM_NCOMPPROCS=10


ARG NB_USER="sudofoam"
ARG NB_UID="1000"
ARG NB_GID="100"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Miniconda installation
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
# Check https://repo.anaconda.com/miniconda/
# Miniconda archive to install
ARG miniconda_version="4.9.2"
# Archive MD5 checksum
ARG miniconda_checksum="122c8c9beb51e124ab32a0fa6426c656"
# Conda version that can be different from the archive
ARG conda_version="4.9.2"

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive

RUN update-ca-certificates && apt-get update \
  && apt-get install --no-install-recommends -y \
  git unzip mercurial libreadline-dev vim nano emacs neovim \
    texlive dvipng \
    wget bzip2 ca-certificates sudo locales fonts-liberation run-one \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    # ---- nbconvert dependencies ----
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    tzdata \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

WORKDIR /root/

# Copy a script that we will use to correct permissions after running certain commands
RUN /bin/bash -c "cp /root/sedfoam/docker/docker-stacks/base-notebook/fix-permissions /usr/local/bin/fix-permissions"
RUN chmod a+rx /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
# hadolint ignore=SC2016
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc && \
   # Add call to conda init script see https://stackoverflow.com/a/58081608/4413446
   echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc

# Create NB_USER with name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

WORKDIR /home/sudofoam
RUN rm -rf .cache

USER 1000
ARG PYTHON_VERSION=default

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION="${miniconda_version}" \
    CONDA_VERSION="${conda_version}"

WORKDIR /tmp
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${miniconda_checksum} *Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    # Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    # FIDLE : Dont' use conda-forge
    # conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda install --quiet --yes \
    "conda=${CONDA_VERSION}" \
    'pip' \
    'tini=0.18.0' && \
    conda update --all --quiet --yes && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN conda install --quiet --yes -n base jupyter pandas  matplotlib && \
    conda clean --all -f -y && \
    pip install --no-cache-dir fluidfoam odfpy

EXPOSE 8888

WORKDIR /root/sedfoam/docker/
RUN /bin/bash -c "sudo cp ./docker-stacks/base-notebook/start.sh ./docker-stacks/base-notebook/start-notebook.sh ./docker-stacks/base-notebook/start-singleuser.sh /usr/local/bin/"
RUN /bin/bash -c "sudo mkdir /etc/jupyter && sudo cp /root/sedfoam/docker/docker-stacks/base-notebook/jupyter_notebook_config.py /etc/jupyter/"

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

USER $NB_UID
WORKDIR /home/sudofoam
ENV HOME /home/sudofoam
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["source /openfoam/bash.rc && jupyter notebook"]

