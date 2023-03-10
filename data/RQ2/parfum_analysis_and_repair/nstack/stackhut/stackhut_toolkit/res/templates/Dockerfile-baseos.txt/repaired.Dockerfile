FROM {{ baseos.name|lower }}:{{ baseos.tag }}
MAINTAINER "StackHut" <stackhut@stackhut.com>
LABEL description="{{ baseos.description }}"

ADD https://bootstrap.pypa.io/get-pip.py /

# update the distro and commit
RUN echo "Starting..." && \
    {% for cmd in baseos.setup_cmds() -%}
    {{ cmd }} && \
    {% endfor -%}
    echo "...done" && exit 0