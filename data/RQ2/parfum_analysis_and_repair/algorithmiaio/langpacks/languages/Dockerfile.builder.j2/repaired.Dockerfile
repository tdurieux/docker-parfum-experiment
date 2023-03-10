FROM {{base_image}}

# Set options that should be defined everywhere
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
LABEL langpacks_version={{langpacks_version}}

# Algo uid is set so that it is known for build caches, but the user id
# would presumably not be used already on our host (which seems better for security)
ENV ALGO_UID=2222
RUN adduser --disabled-password --gecos "" --uid $ALGO_UID algo


RUN mkdir /opt/algorithm
RUN chown $ALGO_UID:$ALGO_UID /opt/algorithm

{% for package in packages %}
################################################################################
# Section for package: {{ package.package_name }}
################################################################################
{% if package.script is not none %}
COPY {{package.script}} /tmp/{{package.script}}
RUN /tmp/{{package.script}}
{% endif %}
{% for line in package.dockerfile -%}
{{line}}
{% endfor %}
{% endfor %}

# The code below creates the /opt/algorithm directory writeable by algo user so that build/run scripts can create directories.
# For example a compiled language like C# creates a bin directory for the compiled binary.

# WORKDIR does not respect the USER operation, which means that /opt/algorithm is owned by root unless previously created
# https://github.com/moby/moby/issues/20295
USER $ALGO_UID

WORKDIR /opt/algorithm