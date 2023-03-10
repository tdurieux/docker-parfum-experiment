# Kaniko does not support copying from an absolute image name, see: https://github.com/GoogleContainerTools/kaniko/issues/297
FROM {{langserver_image}} AS langserver
FROM {{base_image}}

# Set options that should be defined everywhere
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
LABEL langpacks_version={{langpacks_version}}
LABEL langserver_image={{langserver_image}}

# Algo uid is set so that it is known for build caches, but the user id
# would presumably not be used already on our host (which seems better for security)
ENV ALGO_UID=2222
RUN adduser --disabled-password --gecos "" --uid $ALGO_UID algo
COPY --from=langserver /bin/init-langserver /bin/init-langserver
COPY --from=langserver /langserver/target/release/langserver /bin/langserver

{% for package in packages %}
################################################################################
# Section for package: {{ package.package_name }}
################################################################################