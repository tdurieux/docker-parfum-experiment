FROM python:3.6

RUN git clone --branch "v1.0.0" --depth 1 https://github.com/edenhill/librdkafka.git \
 && cd librdkafka \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr \
 && make \
 && make install

RUN git clone --branch "1.4.0" --depth 1 https://github.com/edenhill/kafkacat.git \
 && cd kafkacat \
 && ./bootstrap.sh \
 && cp kafkacat /usr/bin/ \
 && cd .. \
 && rm -rf kafkacat/

RUN mkdir -p /esque

WORKDIR /esque

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir --pre poetry

COPY ./pyproject.toml /esque/pyproject.toml
COPY ./poetry.lock /esque/poetry.lock
RUN poetry config "virtualenvs.create" "false"
RUN poetry install

COPY ./scripts /esque/scripts
COPY ./tests /esque/tests
COPY ./esque /esque/esque
ENTRYPOINT ["/bin/bash"]

CMD ["", "pytest", "tests/"]