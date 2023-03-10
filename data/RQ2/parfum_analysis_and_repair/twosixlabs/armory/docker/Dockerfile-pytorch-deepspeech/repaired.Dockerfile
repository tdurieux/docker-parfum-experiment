ARG base_image_tag
FROM twosixarmory/base:${base_image_tag} as armory-base
ARG armory_version
ARG armory_build_type
# NOTE: installed after pip installs in base container,
#       but doesn't seem to cause issues at the moment
#       pip install librosa does not install sndfile dependency
RUN /opt/conda/bin/conda install -c conda-forge librosa


# TODO: determine if this environment setup is needed
#ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64"

RUN /opt/conda/bin/pip install --no-cache-dir \
    pytorch-lightning==1.4.* \
    torchmetrics==0.7.* \
    git+https://github.com/romesco/hydra-lightning/\#subdirectory=hydra-configs-pytorch-lightning \
    python-levenshtein \
    hydra-core \
    google-cloud-storage \
    sox
# pytorch-lightning >= 1.5.0 will break Deep Speech 2
# torchmetrics >= 0.8.0 will break pytorch-lightning 1.4
# hydra-lightning installs omegaconf
# google-cloud-storage needed for checkpoint.py import
# only sox python bindings are installed; underlying sox binaries not needed

# These are listed as dependencies in PyTorch Deep Speech 2, but they do not appear to be used for inference (only for training), so we do not install them:
#torchelastic
#wget
#flask
#fairscale

# transformers is used for the Entailment metric only
RUN /opt/conda/bin/pip install --no-cache-dir transformers

FROM armory-base AS armory-local
RUN echo "Installing ART"
RUN /opt/conda/bin/pip install --no-cache-dir \
    adversarial-robustness-toolbox==1.10.3

RUN echo "Building Armory from local source"
WORKDIR /armory-repo/
COPY setup.py LICENSE MANIFEST.in README.md requirements.txt test-requirements.txt armory-base-requirements.txt /armory-repo/
COPY pytest.ini /armory-repo/
COPY ./tests /armory-repo/tests/
COPY ./scenario_configs /armory-repo/scenario_configs/
COPY ./armory /armory-repo/armory/
RUN SETUPTOOLS_SCM_PRETEND_VERSION=${armory_version} /opt/conda/bin/pip install --use-feature=in-tree-build --no-cache-dir .
RUN armory configure --use-default

WORKDIR /workspace