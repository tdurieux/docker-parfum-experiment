FROM splatform/stratos-bk-init-base:leap15_2
COPY /deploy/containers/config-init/config-init.sh /config-init.sh
COPY /deploy/tools/generate_cert.sh /generate_cert.sh