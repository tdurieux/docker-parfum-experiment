FROM {{ builder_image }} as builder
ARG CRAN_MIRROR
ARG IVY_MIRROR
ARG MAVEN_MIRROR
ARG NPM_REGISTRY
ARG PYTHON_INDEX_URL
ARG JAVA_TOOL_OPTIONS_BUILD

{# If there is explicit req_files then we add those first and build based on those #}
{% if config.req_files is defined -%}
# Copying dependecies before copying the algo source
{% for build_file in config.req_files -%}
COPY --chown=algo:algo algosource/{{ build_file }} /opt/algorithm/{{ build_file }}
{% endfor %}

{% if local is defined -%}
# Custom CA certs won't be available when testing locally
USER algo
RUN /usr/local/bin/algorithmia-build
{%- else -%}
# customize-container.sh runs as root, then switches to user of less privilege
USER root
COPY mounted-scripts /opt/algorithmiaio/mounted-scripts
COPY ca-certificates /opt/algorithmia/ca-certificates
# Update JAVA_TOOL_OPTIONS with those required for this specific build which might include proxy variables
ENV JAVA_TOOL_OPTIONS "$JAVA_TOOL_OPTIONS_BUILD $JAVA_TOOL_OPTIONS"
RUN /opt/algorithmiaio/mounted-scripts/customize-container-v2.sh algo /usr/local/bin/algorithmia-build
{%- endif %}
{%- endif %}

# Docker build commands don't resolve environment variables so need this to either be numeric or a build argument
COPY --chown=algo:algo algosource /opt/algorithm/

{% if config.local_dependency_src_path is defined -%}
COPY --chown=algo:algo {{config.local_dependency_src_path}} {{config.local_dependency_dest_path}}
{%- endif %}

ENV HOME=/home/algo

{# If there is no explicit req_files we build based on the algorithm source #}
{% if config.req_files is not defined -%}
{% if local is defined -%}
# Custom CA certs won't be available when testing locally
USER algo
RUN /usr/local/bin/algorithmia-build
{% else %}
# customize-container.sh runs as root, then switches to user of less privilege
USER root
COPY mounted-scripts /opt/algorithmiaio/mounted-scripts
COPY ca-certificates /opt/algorithmia/ca-certificates
# Update JAVA_TOOL_OPTIONS with those required for this specific build which might include proxy variables
ENV JAVA_TOOL_OPTIONS "$JAVA_TOOL_OPTIONS_BUILD $JAVA_TOOL_OPTIONS"
RUN /opt/algorithmiaio/mounted-scripts/customize-container-v2.sh algo /usr/local/bin/algorithmia-build
{%- endif %}
{%- endif %}

################################################################################
FROM {{ runner_image }}

{% for artifact in config.artifacts -%}
COPY --from=builder --chown=algo:algo {{artifact.source}} {{artifact.destination}}
{% endfor %}
USER algo
WORKDIR /opt/algorithm
ENTRYPOINT /bin/init-langserver