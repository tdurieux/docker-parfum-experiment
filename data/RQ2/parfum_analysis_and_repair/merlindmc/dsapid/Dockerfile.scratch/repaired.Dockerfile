FROM scratch

ARG dsapid_version
ARG dsapid_commit=HEAD

LABEL "dsapid.version"="${dsapid_version}"
LABEL "dsapid.commit"="${dsapid_commit}"

ENTRYPOINT [ "/server" ]

ADD dsapid /server