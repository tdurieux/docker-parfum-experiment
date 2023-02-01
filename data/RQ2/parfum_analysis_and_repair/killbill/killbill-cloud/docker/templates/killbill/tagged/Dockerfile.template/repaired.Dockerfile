FROM killbill/killbill
LABEL maintainer="killbilling-users@googlegroups.com"

# VERSION will be expanded in Makefile
ENV KILLBILL_VERSION=__VERSION__

# Default kpm.yml, override as needed
COPY ./kpm.yml $KILLBILL_INSTALL_DIR

# Run both the main playbook and the one enabling structured logging
RUN $KPM_INSTALL_CMD $KILLBILL_CLOUD_ANSIBLE_ROLES/killbill_json_logging.yml

# Override start script (no need for Ansible scripts to be run)
COPY ./killbill.sh $KILLBILL_INSTALL_DIR