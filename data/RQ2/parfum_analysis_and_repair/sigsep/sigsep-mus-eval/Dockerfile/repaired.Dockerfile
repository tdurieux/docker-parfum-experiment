FROM continuumio/miniconda3

WORKDIR /museval

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsndfile1-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip wheel
RUN conda install numpy scipy cffi
RUN conda install -c conda-forge ffmpeg==3.4 libsndfile
RUN git clone https://github.com/sigsep/sigsep-mus-eval /src && pip install --no-cache-dir -e /src

ENTRYPOINT ["/opt/conda/bin/museval"]
