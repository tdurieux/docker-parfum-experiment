FROM stackhut/{{ baseos.name|lower }}:latest
MAINTAINER "StackHut" <stackhut@stackhut.com>
LABEL description="{{ stack.description }}"

{% if stack_cmds %}
# install OS packages needed for stack
RUN echo "Starting..." && \
    {% for cmd in stack_cmds -%}
    {{ cmd }} && \
    {% endfor -%}
    echo "...done" && exit
{% endif %}

{% if stack.stack_packages %}
# install lang packages needed for stack
RUN {{ stack.install_stack_packages() }}
{% endif %}