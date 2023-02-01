FROM blockstream/verde@sha256:1c92ae02ed4eba206df45f321fbd3051944bc79989705994ebea23d5714ae3ea

RUN echo "source /root/esp/esp-idf/export.sh" >> /etc/bash.bashrc

COPY .git /host/jade/.git
RUN git clone /host/jade/ /jade
WORKDIR /jade
RUN git submodule init
RUN git submodule update