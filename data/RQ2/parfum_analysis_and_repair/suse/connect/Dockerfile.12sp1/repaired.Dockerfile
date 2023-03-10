FROM registry.scc.suse.de/suse/sles12:sp1
ENV PRODUCT SLE_12_SP1
ENV BUILT_AT "Tue May 9 14:46 CET 2017"

RUN useradd --no-log-init --create-home scc

ARG OBS_USER
ARG OBS_PASSWORD

RUN zypper --non-interactive --no-refresh rm container-suseconnect &&\
    zypper ar http://download.suse.de/ibs/SUSE/Products/SLE-SERVER/12-SP1/x86_64/product/ SLE-12-SP1-standard &&\
    zypper ar -f http://download.suse.de/ibs/SUSE/Updates/SLE-SERVER/12-SP1/x86_64/update/ SLE-12-SP1-updates &&\
    zypper ar -f http://download.suse.de/ibs/SUSE/Updates/SLE-SERVER/12-SP1-LTSS/x86_64/update/ SLE-12-SP1-ltss &&\
    zypper --no-gpg-checks ar http://download.suse.de/ibs/SUSE/Products/SLE-SDK/12-SP1/x86_64/product/ sle12sp1sdk &&\
    zypper --no-gpg-checks ar http://download.suse.de/ibs/SUSE/Updates/SLE-SDK/12-SP1/x86_64/update/ sle12sp1sdk-updates &&\
    zypper --non-interactive --gpg-auto-import-keys ref &&\
    zypper --non-interactive up zypper &&\
    zypper --non-interactive install git-core ruby-devel make gcc gcc-c++ build wget dmidecode \
      vim osc ruby2.1-rubygem-gem2rpm hwinfo libx86emu1 zypper-migration-plugin sudo curl && \
    zypper --non-interactive rr SLE-12-SP1-standard SLE-12-SP1-updates sle12sp1sdk sle12sp1sdk-updates

COPY integration/create-oscrc.sh /tmp/connect/integration/create-oscrc.sh
RUN sh /tmp/connect/integration/create-oscrc.sh

RUN echo 'gem: --no-ri --no-rdoc' > /etc/gemrc && \
    gem install bundler --version '~> 1.17' --no-document

RUN mkdir -p /tmp/connect/lib/suse/connect
WORKDIR /tmp/connect

COPY Gemfile .
COPY suse-connect.gemspec .
COPY lib/suse/connect/version.rb ./lib/suse/connect/
RUN bundle config jobs $(nproc) && \
    bundle install
COPY . /tmp/connect
RUN chown -R scc /tmp/connect