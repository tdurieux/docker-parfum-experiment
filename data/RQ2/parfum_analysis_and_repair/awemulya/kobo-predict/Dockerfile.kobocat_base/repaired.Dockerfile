# Base image to take care of installing `apt` and `pip` requirements. Also clones the `kobocat-template` repo.

FROM kobotoolbox/base-kobos:latest


ENV KOBOCAT_SRC_DIR=/srv/src/kobocat \
    KOBOCAT_TMP_DIR=/srv/kobocat_tmp \
    # Store editable packages (pulled from VCS repos) in their own directory.
    PIP_EDITABLE_PACKAGES_DIR=/srv/pip_editable_packages


###########################
# Install `apt` packages. #
###########################

COPY ./apt_requirements.txt ${KOBOCAT_TMP_DIR}/base_apt_requirements.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y $(cat ${KOBOCAT_TMP_DIR}/base_apt_requirements.txt) && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


###########################
# Install `pip` packages. #
###########################

COPY ./requirements/ ${KOBOCAT_TMP_DIR}/base_requirements/
RUN mkdir -p ${PIP_EDITABLE_PACKAGES_DIR} && \
    pip install --no-cache-dir --src ${PIP_EDITABLE_PACKAGES_DIR}/ -r ${KOBOCAT_TMP_DIR}/base_requirements/base.pip && \
    pip install --no-cache-dir --src ${PIP_EDITABLE_PACKAGES_DIR}/ -r ${KOBOCAT_TMP_DIR}/base_requirements/s3.pip


################################
# Install `kobocat-templates`. #
################################

RUN mkdir -p /srv/src && \
    cd /srv/src && \
    git clone --depth 1 https://github.com/kobotoolbox/kobocat-template.git -b master && \
    chown -R wsgi /srv/src/kobocat-template
