FROM ubuntu:xenial
MAINTAINER Victor Felder <victorfelder@gmail.com>

ENV PATH=/usr/local/depot_tools:"$PATH"
ENV LD_LIBRARY_PATH=/usr/local/lib

<% if (tag) { %>ENV V8_TAG="<%= tag %>"<% }%>
<% if (chromeVersion) { %>ENV CHROME_VERSION="<%= chromeVersion %>"<% }%>
<% if (nodeVersion) { %>ENV NODE_VERSION="<%= nodeVersion %>"<% }%>
ENV BUILT_WITH=gn-ninja

COPY test.js /tmp

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/no-lang && \
    apt-get update && \
    echo 'localepurge localepurge/nopurge multiselect en_US,en_US.UTF-8\nlocalepurge localepurge/use-dpkg-feature boolean true' | debconf-set-selections && \
    apt-get install --no-install-recommends -y git wget curl build-essential libglib2.0-dev localepurge ca-certificates && \

    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/depot_tools && \
    cd /usr/local && \
    fetch v8 && \
    cd /usr/local/v8 && \<% if (tag) { %>
    git checkout <%= tag %> || exit 11 && \<% } else { %>
    git checkout master && git pull && \<% }%>
    gclient sync && \
    tools/dev/v8gen.py x64.release && \
    gn gen out.gn/x64.release \
    --args='v8_use_external_startup_data=false v8_enable_disassembler=true v8_object_print=true is_debug=true target_cpu="x64"' || exit 13 && \
    ninja -C out.gn/x64.release d8 || exit 15 && \
    cd /usr/local/v8/out.gn/x64.release && \
    cp d8 /usr/local/bin/d8 && \
    cp lib*.so* /usr/local/lib/ && \
    rm /usr/local/lib/*.TOC && \
    cd /tmp `# test the build` && \
    d8 --trace-hydrogen --trace-phase=Z --trace-deopt \
    --code-comments --hydrogen-track-positions --redirect-code-traces \
    --redirect-code-traces-to=/tmp/out.asm --print-opt-code /tmp/test.js && \
    rm test.js hydrogen.cfg `# crash if any of these doesn't exist` && \
    rm out.asm || touch /no_asm_redirect && \
    cd / `# cleanup` && \
    rm -rf /usr/local/depot_tools && \
    rm -rf /usr/local/v8 && \
    apt-get purge -y git wget curl build-essential libglib2.0-dev localepurge && \
    apt-get autoremove -y && \
    apt-get clean -y all && \
    cd / && \
    rm -rf \
       doc \
       man \
       info \
       locale \
       /var/lib/apt/lists/* \
       /var/log/* \
       /var/cache/debconf/* \
       /var/tmp/* \
       common-licenses \
       ~/.bashrc \
       /etc/systemd \
       /lib/lsb \
       /lib/udev \
       /usr/share/doc/ \
       /usr/share/doc-base/ \
       /usr/share/man/ \
       /tmp/*

CMD ["/usr/local/bin/d8"]