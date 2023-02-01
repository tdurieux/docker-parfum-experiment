FROM conanio/gcc9:1.22.2

RUN pip install --no-cache-dir clang-format

USER root

WORKDIR absent

COPY . .

CMD ["/bin/bash"]
