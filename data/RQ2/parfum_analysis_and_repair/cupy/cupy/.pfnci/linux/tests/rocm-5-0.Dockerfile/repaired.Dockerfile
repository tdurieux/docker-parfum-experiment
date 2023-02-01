# AUTO GENERATED: DO NOT EDIT!
ARG BASE_IMAGE="rocm/dev-ubuntu-20.04:5.0"
FROM ${BASE_IMAGE}

RUN export DEBIAN_FRONTEND=noninteractive && \
    ( apt-get -qqy update || true ) && \
    apt-get -qqy --no-install-recommends install ca-certificates && \
    curl -f -qL https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - && rm -rf /var/lib/apt/lists/*;
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
       make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget \
       curl llvm libncursesw5-dev xz-utils tk-dev \
       libxml2-dev libxmlsec1-dev libffi-dev \
       liblzma-dev && \
    apt-get -qqy --no-install-recommends install ccache git curl && \
    apt-get -qqy --no-install-recommends --allow-change-held-packages \
            --allow-downgrades install rocm-dev hipblas hipfft hipsparse hipcub rocsparse rocrand rocthrust rocsolver rocfft rocprim rccl && rm -rf /var/lib/apt/lists/*;

ENV PATH "/usr/lib/ccache:${PATH}"

ENV ROCM_HOME "/opt/rocm"
ENV LD_LIBRARY_PATH "${ROCM_HOME}/lib"
ENV CPATH "${ROCM_HOME}/include"
ENV LDFLAGS "-L${ROCM_HOME}/lib"

RUN git clone https://github.com/pyenv/pyenv.git /opt/pyenv
ENV PYENV_ROOT "/opt/pyenv"
ENV PATH "${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
RUN pyenv install 3.9.6 && \
    pyenv global 3.9.6 && \
    pip install --no-cache-dir -U setuptools pip

RUN pip install --no-cache-dir -U 'numpy==1.23.*' 'scipy==1.8.*' 'optuna==2.*' 'cython==0.29.*'
