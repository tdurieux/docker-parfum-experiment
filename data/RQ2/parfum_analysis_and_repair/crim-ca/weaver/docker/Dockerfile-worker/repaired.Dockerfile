FROM weaver:base
LABEL description.short="Weaver Worker"

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        curl \
        gnupg \
        gnupg-agent \
        software-properties-common \
    # NOTE: Only 'worker' image should be using docker, 'manager' is only for API.
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
    && apt update \
    # NOTE:
    #   Only install CLI package, 'docker-ce' and 'containerd.io' not required as they should be provided by host.
    #   Docker sibling execution is expected. See 'docker/docker-compose.yml.example' for details. \
    && apt install -y --no-install-recommends docker-ce-cli \
	&& rm -rf /var/lib/apt/lists/*

# run app
# see CHANGES (4.15.0), celery>=5 needs '-A' before 'worker'
CMD celery -A pyramid_celery.celery_app worker -B -E --ini "${APP_CONFIG_DIR}/weaver.ini"
