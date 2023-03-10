FROM ubuntu:18.04 as build-stage

WORKDIR /usr/src/app

ENV LANG="C.UTF-8" LC_ALL="C.UTF-8" PATH="/opt/venv/bin:$PATH" PIP_NO_CACHE_DIR="false" CFLAGS="-mavx2 -mf16c" CXXFLAGS="-mavx2 -mf16c"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-dev wget make g++ libblas-dev liblapack-dev swig patch && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN python3 -m venv /opt/venv && \
    python3 -m pip install pip==19.3.1 pip-tools==4.2.0 wheel==0.33.6

RUN python3 -m piptools sync

COPY patches .

RUN wget -q https://github.com/facebookresearch/faiss/archive/v1.6.0.tar.gz -O faiss.tar.gz && \
    echo "71a47cbb00aa0ae09b77a70d3fa1617bf7861cc7d41936458b88c7a161b03660  faiss.tar.gz" | sha256sum -c && \
    tar xf faiss.tar.gz && \
    rm faiss.tar.gz && \
    cd faiss* && \
    ls .. && \
    patch -p1 < ../faiss-fix-compilation-for-mavx2.patch && \
    patch -p1 < ../faiss-fix-python-module-prints.patch && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-cuda && \
    make -j $(nproc) && \
    cd python && \
    make -j $(nproc) && \
    python3 setup.py bdist_wheel && \
    cd ../../ && \
    python3 -m pip install faiss*/python/dist/faiss*.whl && \
    cp faiss*/python/dist/faiss*.whl /opt/ && \
    rm -rf faiss*



FROM ubuntu:18.04 as dev-stage

WORKDIR /usr/src/app

ENV LANG="C.UTF-8" LC_ALL="C.UTF-8" PATH="/opt/venv/bin:$PATH" PIP_NO_CACHE_DIR="false"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv libglib2.0-0 libblas3 liblapack3 libgomp1 && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN python3 -m venv /opt/venv && \
    python3 -m pip install pip==19.3.1 pip-tools==4.2.0

RUN echo "https://download.pytorch.org/whl/cpu/torch-1.3.0%2Bcpu-cp36-cp36m-linux_x86_64.whl        \
          --hash=sha256:ce648bb0c6b86dd99a8b5598ae6362a066cca8de69ad089cd206ace3bdec0a5f            \
          \n                                                                                        \
          https://download.pytorch.org/whl/cpu/torchvision-0.4.1%2Bcpu-cp36-cp36m-linux_x86_64.whl  \
          --hash=sha256:593ad12c3c8ce16068566c9eb2bfb39f4834c89a2cc9f0b181e9121b06046b3e            \
          \n" >> requirements.txt

RUN python3 -m piptools sync

COPY --from=build-stage /opt/faiss*.whl /opt
RUN python3 -m pip install /opt/faiss*.whl && \
    rm /opt/faiss*.whl

COPY . .

ENTRYPOINT ["/usr/src/app/bin/ig65m"]
CMD ["-h"]
