ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-buster
ENV HOME=/root
ARG WORKDIR

ENV JUMAN_VERSION 7.01
ENV JUMAN_URL "http://nlp.ist.i.kyoto-u.ac.jp/DLcounter/lime.cgi?down=http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2&name=juman-7.01.tar.bz2"
ENV JUMANPP_VERSION "2.0.0-rc3"
ENV JUMANPP_URL "https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc3/jumanpp-2.0.0-rc3.tar.xz"

# install juman
RUN cd /tmp && \
    wget ${JUMANPP_URL} && apt -y update && apt install --no-install-recommends -y cmake && tar xf jumanpp-${JUMANPP_VERSION}.tar.xz && \
    cd jumanpp-${JUMANPP_VERSION} && mkdir bld && cd bld && cmake .. -DCMAKE_BUILD_TYPE=Release && make install && rm -rf /tmp/* && rm jumanpp-${JUMANPP_VERSION}.tar.xz && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp && \
    wget ${JUMAN_URL} -O juman.tar.bz2 && tar jxvf juman.tar.bz2 && cd juman-${JUMAN_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && \
    rm -rf /tmp/* && rm juman.tar.bz2
RUN ldconfig

# install poetry
RUN pip install --no-cache-dir -U poetry && \
    poetry config virtualenvs.create false

# install python dependencies
RUN mkdir ${HOME}/camphr && \
    touch ${HOME}/camphr/__init__.py && \
    touch ${HOME}/README.md
WORKDIR ${HOME}/${WORKDIR}
COPY ${WORKDIR}/pyproject.toml .
COPY pyproject.toml ${HOME}/
ARG INSTALL_CMD
run ${INSTALL_CMD}

# install source
COPY . ${HOME}
RUN poetry install
