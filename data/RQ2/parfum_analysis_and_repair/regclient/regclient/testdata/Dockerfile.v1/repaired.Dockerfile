FROM scratch

COPY layer1.txt /layer1
ARG  arg=value
ARG  arg_label
LABEL arg_label=${arg_label}
LABEL version=1
VOLUME /volume