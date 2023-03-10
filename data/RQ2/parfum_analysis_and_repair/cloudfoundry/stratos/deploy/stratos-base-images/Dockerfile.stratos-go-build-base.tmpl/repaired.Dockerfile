FROM {{BASE_IMAGE}}

{{#IS_SLE}}
RUN rm -f /usr/lib/zypp/plugins/services/container-suseconnect-zypp
RUN zypper addrepo -G -c -p 90 '{{ZYP_REPO_BASE_GA}}' base_ga
RUN zypper addrepo -G -c -p 80 '{{ZYP_REPO_BASE_UPDATE}}' base_update
RUN zypper addrepo -G -c -p 70 '{{ZYP_REPO_SP_GA}}' sp_ga
RUN zypper addrepo -G -c -p 60 '{{ZYP_REPO_SP_UPDATE}}' sp_update
RUN zypper ref
{{/IS_SLE}}

RUN zypper -n ref && \
    zypper -n up && \
    zypper in -y which tar git gcc curl wget gzip xz unzip make && \
    zypper clean -a && \
    rm -f /var/log/zypper.log /var/log/zypp/history

RUN wget https://storage.googleapis.com/golang/go1.13.4.linux-amd64.tar.gz && \
    tar -xzf go1.13.4.linux-amd64.tar.gz -C /usr/local/ && \
    rm go1.13.4.linux-amd64.tar.gz && \
    mkdir -p /home/stratos/go/bin && \
    mkdir -p /home/stratos/go/src
    
ENV PATH $PATH:/usr/local/go/bin:/home/stratos/go/bin
ENV GOPATH /home/stratos/go

{{#IS_SLE}}
RUN zypper rr base_ga
RUN zypper rr base_update
RUN zypper rr sp_ga
RUN zypper rr sp_update
{{/IS_SLE}}

WORKDIR /home/stratos/go