ARG base_image_tag
FROM twosixarmory/base:${base_image_tag} as armory-base
ARG armory_version
ARG armory_build_type

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