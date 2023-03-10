# This Dockerfile can be built by running `make build-webapp-plugins` in the root of this project
ARG docker_repo=zokradonh
FROM ${docker_repo}/kopano_webapp

ENV \
    KCCONF_WEBAPPPLUGIN_MDM_PLUGIN_MDM_USER_DEFAULT_ENABLE_MDM=true \
    KCCONF_WEBAPPPLUGIN_MDM_PLUGIN_MDM_SERVER=kopano_zpush:9080 \
    KCCONF_WEBAPPPLUGIN_MDM_PLUGIN_MDM_SERVER_SSL=false

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    "${ADDITIONAL_KOPANO_PACKAGES}" \
    "${ADDITIONAL_KOPANO_WEBAPP_PLUGINS}" \
    kopano-webapp-plugin-files \
    kopano-webapp-plugin-filesbackend-owncloud \
    kopano-webapp-plugin-intranet \
    kopano-webapp-plugin-mdm \
    kopano-webapp-plugin-pimfolder \
    kopano-webapp-plugin-smime \
    && rm -rf /var/cache/apt /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

# tweak to make the container read-only
RUN mkdir -p /tmp/webapp/ && \
    for i in /etc/kopano/webapp/* /etc/kopano/webapp/.[^.]*; do \
        if [ -L "$i" ]; then \
            continue; \
        fi; \
        if [[ "$i" = *.dist ]]; then \
            continue; \
        fi; \
        mv -v "$i" "$i.dist"; \
        ln -s /tmp/webapp/"$(basename "$i")" "$i"; \
    done
