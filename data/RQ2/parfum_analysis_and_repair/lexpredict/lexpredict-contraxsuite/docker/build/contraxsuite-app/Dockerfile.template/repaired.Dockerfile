FROM ${CONTRAXSUITE_IMAGE_FROM}
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

COPY ./temp/contraxsuite_services /contraxsuite_services
COPY ./temp/python-requirements-additional.txt /contraxsuite_services/python-requirements-additional.txt
COPY ./temp/additionals /
COPY ./temp/ssl_certs /
COPY ./install_ssl_certs_to_python.sh /
COPY ./temp/build.info /
COPY ./temp/build.uuid /
COPY ./temp/start.sh /contraxsuite_services/
COPY ./webdav_upload.sh /
COPY ./dump.sh /contraxsuite_services/
COPY ./check_celery.sh /
COPY ./temp/static /static

RUN adduser -u ${SHARED_USER_ID} --disabled-password --gecos "" ${SHARED_USER_NAME}
RUN usermod -a -G root ${SHARED_USER_NAME}

#echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic main restricted universe multiverse" > /etc/apt/sources.list && \
#echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
#
# Not using mirrors here because it returns non-working mirrors.

RUN apt-get -y update --fix-missing && \
    apt-get install -y -q apt-utils lsb-release gcc-9 g++ software-properties-common wget apt-transport-https locales && \
	echo "Ubuntu version: " && lsb_release -a && \
	echo "GCC version: " && gcc-9 -v && \
	add-apt-repository -y ppa:openjdk-r/ppa && \
	apt-get -y update --fix-missing && \
	apt-get install -y openjdk-8-jdk libpq5 postgresql-client-12 && \
	cat /contraxsuite_services/deploy/base/debian-requirements.txt \
    | grep -v -E "^postgresql${DOLLAR}" \
    | grep -v -E "^#" \
    | xargs -r apt-get -y -q install && \
  egrep -v '^(#|$)' /contraxsuite_services/deploy/base/supported_locales.txt \
    | xargs -r locale-gen --purge && \
	echo -e \'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n\' > /etc/default/locale && \
	npm -g install yuglify && \
	apt-get install -y curl htop python3-dev python3-pip dnsutils iputils-ping nano mc && \
	python3 --version && pip3 install -r /contraxsuite_services/deploy/base/python-requirements-all-3.8.txt && pip3 install --no-warn-conflicts --no-deps -r /contraxsuite_services/deploy/base/python-requirements-ignore-conflicts.txt${LEXNLP_MASTER_INSTALL_CMD} ${TEXT_EXTRACTION_API_INSTALL_CMD} && pip3 install -r /contraxsuite_services/python-requirements-additional.txt && pip3 uninstall -y -r /contraxsuite_services/deploy/base/python-unwanted-requirements.txt && \
	if [ -f  /contraxsuite_services/deploy/base/customer-requirements.txt ]; then \
    pip3 install -r /contraxsuite_services/deploy/base/customer-requirements.txt; fi && \
    su - ${SHARED_USER_NAME} -c "python3 -m nltk.downloader averaged_perceptron_tagger punkt stopwords words maxent_ne_chunker wordnet omw-1.4" && \
    su - ${SHARED_USER_NAME} -c "python3 -c 'from lexnlp.ml.catalog.download import download_github_release; download_github_release(\"pipeline/is-contract/0.1\", False); download_github_release(\"pipeline/contract-type/0.1\", False)'" && \
    su - ${SHARED_USER_NAME} -c "test -f \"/static/vendor/jqwidgets/jqx-all.js\" && echo \"JQWidgets are bundled within the image. Running collectstatic...\" && python3 manage.py collectstatic --noinput || echo \"JQWidgets not bundled within the image.\"" && \
    cat /build.info && cat /build.uuid && ls /static -l && \
    . /install_ssl_certs_to_python.sh && \
    apt-get purge -y gcc-9 g++ build-essential linux-headers* && \
	apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt && \
    rm -rf /var/lib/dpkg && \
    rm -rf /var/lib/cache && \
    rm -rf /var/lib/log && \
    rm -rf /root/.cache/pip/ && \
    rm -rf /lexpredict-contraxsuite-core/.git/ && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /ssl_certs && \
    rm /install_ssl_certs_to_python.sh && \
    echo ${DOLLAR}(date) > /build.date && \
    echo "Contraxsuite Git branch: ${BUILD_CONTRAXSUITE_GIT_BRANCH}" > /build_info.txt && \
    echo "Contraxsuite commit: ${BUILD_CONTRAXSUITE_GIT_COMMIT}" >> /build_info.txt && \
    echo "Lexnlp Core branch: ${BUILD_LEXNLP_CORE_GIT_BRANCH}" >> /build_info.txt && \
    echo "Lexnlp Core commit: ${BUILD_LEXNLP_CORE_GIT_COMMIT}" >> /build_info.txt && \
    echo "Customer repo branch: ${BUILD_CUSTOMER_REPO_GIT_BRANCH}" >> /build_info.txt && \
    echo "Customer repo commit: ${BUILD_CUSTOMER_REPO_GIT_COMMIT}" >> /build_info.txt && \
    mkdir -p /contraxsuite_services/staticfiles && \
    chown -R -v ${SHARED_USER_NAME}:${SHARED_USER_NAME} /contraxsuite_services && \
    chmod ugo+x /contraxsuite_services/start.sh && \
    mkdir -p /data/data && \
    mkdir -p /data/logs && \
    mkdir -p /static && \
    mkdir -p /deployment_uuid && \
    mkdir -p /data/celery_worker_state && \
    mkdir -p /contraxsuite_frontend_nginx_volume && \
    if [ -d  /contraxsuite_frontend ]; then chown -R -v ${SHARED_USER_NAME}:${SHARED_USER_NAME} /contraxsuite_frontend; fi && \
    chown -R -v ${SHARED_USER_NAME}:${SHARED_USER_NAME} /data && \
    chown -R -v ${SHARED_USER_NAME}:${SHARED_USER_NAME} /static && \
    chown -R -v ${SHARED_USER_NAME}:${SHARED_USER_NAME} /contraxsuite_frontend_nginx_volume

STOPSIGNAL SIGQUIT
USER ${SHARED_USER_NAME}
WORKDIR /contraxsuite_services
ENTRYPOINT ["./start.sh"]