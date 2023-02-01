FROM ubuntu:18.04

ENV LANG "ja_JP.UTF-8"
ENV PYTHONIOENCODING "utf-8"

RUN apt update -y && \
    apt install --no-install-recommends -y libprotobuf-dev libgoogle-perftools-dev \
    language-pack-ja build-essential \
    wget git g++ make cmake vim \
    python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

# kytea
RUN wget https://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz && \
    tar zxvf kytea-0.4.7.tar.gz && cd kytea-0.4.7 && \
    wget https://patch-diff.githubusercontent.com/raw/neubig/kytea/pull/24.patch && \
    git apply ./24.patch && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && make install && ldconfig -v && rm kytea-0.4.7.tar.gz

# jumanpp
RUN wget https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc3/jumanpp-2.0.0-rc3.tar.xz && \
    tar xvf jumanpp-2.0.0-rc3.tar.xz && \
    cd jumanpp-2.0.0-rc3 && mkdir build && cd build && cmake .. && make install && rm jumanpp-2.0.0-rc3.tar.xz


WORKDIR /workspace
COPY . toiro

RUN pip3 install --no-cache-dir -U pip
RUN cd toiro && pip3 install --no-cache-dir .[all_tokenizers]

CMD ["/bin/bash"]
