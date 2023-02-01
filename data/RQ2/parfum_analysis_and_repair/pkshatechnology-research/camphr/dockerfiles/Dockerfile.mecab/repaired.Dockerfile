ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-buster
ENV HOME=/root
ARG WORKDIR

ENV MECAB_URL "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE"
ENV IPADIC_URL "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"

# install mecab
RUN cd /tmp && \
    wget --no-check-certificate ${MECAB_URL} -O mecab.tar.gz && \
    tar xzvf mecab.tar.gz && cd mecab-0.996 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install && \
    rm -rf /tmp/* && rm mecab.tar.gz
# install ipadic
RUN cd /tmp && \
    wget --no-check-certificate ${IPADIC_URL} -O ipadic.tar.gz && \
    tar xzvf ipadic.tar.gz && cd mecab-ipadic-2.7.0-20070801 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-charset=utf8 && ldconfig && make && make install && \
    rm -rf /tmp/* && rm ipadic.tar.gz

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
