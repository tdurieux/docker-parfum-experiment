FROM registry.scc.suse.de/suse/sles12:sp2
ENV PRODUCT SLE_12_SP2
ENV BUILT_AT "Tue May 9 14:46 CET 2017"

RUN useradd --no-log-init --create-home scc

ARG OBS_USER
ARG OBS_PASSWORD

RUN zypper --non-interactive ar http://download.suse.de/ibs/SUSE/Products/SLE-SERVER/12-SP2/x86_64/product/ SLE-12-SP2-standard &&\
    zypper ar -f http://download.suse.de/ibs/SUSE/Updates/SLE-SERVER/12-SP2/x86_64/update/ SLE-12-SP2-updates &&\
    zypper ar http://download.suse.de/ibs/SUSE/Products/SLE-SDK/12-SP2/x86_64/product/ sle12sp2sdk &&\
    zypper ar http://download.suse.de/ibs/SUSE/Updates/SLE-SDK/12-SP2/x86_64/update/ sle12sp2sdk-updates &&\
    zypper --non-interactive --gpg-auto-import-keys ref &&\
    zypper --non-interactive up zypper &&\
    zypper --non-interactive install git-core ruby-devel make gcc gcc-c++ build wget dmidecode \
      vim osc ruby2.1-rubygem-gem2rpm hwinfo libx86emu1 zypper-migration-plugin sudo curl && \
    zypper --non-interactive rr SLE-12-SP2-standard SLE-12-SP2-updates sle12sp2sdk sle12sp2sdk-updates

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