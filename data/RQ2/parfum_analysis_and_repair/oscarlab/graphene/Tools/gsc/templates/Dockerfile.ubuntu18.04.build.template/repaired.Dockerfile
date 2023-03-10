# Include previously-prepared Docker image with Graphene (if any) or compile Graphene from sources
{% if Graphene.Image %}
FROM gsc-{{Graphene.Image}} AS graphene
{% else %}
{% include "Dockerfile.ubuntu18.04.compile.template" %}
{% endif %}

# Combine Graphene image with the original app image
FROM {{app_image}}

RUN apt-get update \
    && env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        binutils \
        libprotobuf-c-dev \
        locales \
        locales-all \
        openssl \
        python3 \
        python3-pip \
        python3-protobuf \
    && python3 -B -m pip install protobuf jinja2 toml>=0.10

{% if debug %}
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y gdb less strace vim python3-pyelftools
{% endif %}

RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Copy Graphene runtime and signer tools to /graphene/meson_build_output
RUN mkdir -p /graphene/Tools \
    && mkdir -p /graphene/meson_build_output

# TODO: remove this copy after argv_serializer becomes a part of Meson build
COPY --from=graphene /graphene/Tools/argv_serializer /graphene/Tools
COPY --from=graphene /graphene/meson_build_output /graphene/meson_build_output

# Copy helper scripts and Graphene manifest
COPY *.py /
COPY apploader.sh /
COPY entrypoint.manifest /

# Generate trusted arguments if required
{% if not insecure_args %}
RUN /graphene/Tools/argv_serializer {{binary}} {{binary_arguments}} "{{"\" \"".join(cmd)}}" > /trusted_argv
{% endif %}

# Docker entrypoint/cmd typically contains only the basename of the executable so create a symlink
RUN cd / \
    && which {{binary}} | xargs ln -s || true

# Include Meson build output directory in $PATH
ENV PATH="/graphene/meson_build_output/bin:$PATH"

# Mark apploader.sh executable, finalize manifest, and remove intermediate scripts
RUN chmod u+x /apploader.sh \
    && python3 -B /finalize_manifest.py \
    && rm -f /finalize_manifest.py

# Define default command