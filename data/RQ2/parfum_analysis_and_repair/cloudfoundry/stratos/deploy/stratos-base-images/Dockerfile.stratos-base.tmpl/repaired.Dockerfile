FROM {{BASE_IMAGE}}

{{#IS_SLE}}
RUN rm -f /usr/lib/zypp/plugins/services/container-suseconnect-zypp
{{/IS_SLE}}

WORKDIR /srv