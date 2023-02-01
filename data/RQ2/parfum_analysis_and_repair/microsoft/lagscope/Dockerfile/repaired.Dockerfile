FROM gcc

RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential cmake && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/microsoft/lagscope.git

WORKDIR lagscope

RUN ./do-cmake.sh build && \
    ./do-cmake.sh install

FROM fedora

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3 /tmp/get-pip.py && \
    pip3 install --no-cache-dir matplotlib pandas numpy && \
    dnf install -y python3-tkinter iputils

COPY --from=0 /usr/local/bin/lagscope /bin/
COPY --from=0 /lagscope/src/visualize_data.py /

ENV MPLCONFIGDIR /tmp

CMD ["/bin/bash"]
