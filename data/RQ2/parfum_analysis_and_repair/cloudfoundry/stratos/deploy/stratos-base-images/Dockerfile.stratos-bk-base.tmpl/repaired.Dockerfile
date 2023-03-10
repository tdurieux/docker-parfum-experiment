FROM {{BASE_IMAGE}}

{{#IS_SLE}}
RUN rm -f /usr/lib/zypp/plugins/services/container-suseconnect-zypp
RUN zypper addrepo -G -c -p 90 '{{ZYP_REPO_BASE_GA}}' base_ga
RUN zypper addrepo -G -c -p 80 '{{ZYP_REPO_BASE_UPDATE}}' base_update
RUN zypper addrepo -G -c -p 70 '{{ZYP_REPO_SP_GA}}' sp_ga
RUN zypper addrepo -G -c -p 60 '{{ZYP_REPO_SP_UPDATE}}' sp_update
RUN zypper ref
{{/IS_SLE}}
RUN zypper in -y ca-certificates && \
    zypper in -y curl && \
    zypper in -y bind-utils && \
    zypper in -y hostname && \
    mkdir -p /srv && \
    mkdir -p /root/.npm-global
# Install latest git from devel/tools/scm repository
{{^IS_SLE}}
RUN zypper ar -p 50 http://download.opensuse.org/repositories/devel:/tools:/scm/openSUSE_Leap_15.1/devel:tools:scm.repo && \
    zypper --no-gpg-checks in -y git && \
    zypper rr devel_tools_scm && \
    zypper clean -a && \
    rm -f /var/log/zypper.log /var/log/zypp/history
{{/IS_SLE}}
{{#IS_SLE}}
RUN zypper ar http://download.opensuse.org/repositories/devel:/tools:/scm/SLE_15/devel:tools:scm.repo && \
    zypper --no-gpg-checks in -y git && \
    zypper rr devel_tools_scm && \
    zypper clean -a && \
    rm -f /var/log/zypper.log /var/log/zypp/history
{{/IS_SLE}}

{{#IS_SLE}}
RUN zypper rr base_ga
RUN zypper rr base_update
RUN zypper rr sp_ga
RUN zypper rr sp_update
{{/IS_SLE}}
WORKDIR /srv