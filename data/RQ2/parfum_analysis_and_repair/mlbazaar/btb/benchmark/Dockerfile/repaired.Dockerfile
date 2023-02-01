FROM daskdev/dask:2.8.0

RUN mkdir -p /workdir/btb && \
    mkdir -p /workdir/btb_benchmark && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential swig && rm -rf /var/lib/apt/lists/*;

COPY setup.py MANIFEST.in /workdir/btb/
COPY benchmark/setup.py /workdir/btb_benchmark/
RUN pip install --no-cache-dir -e /workdir/btb[dev] -e

COPY btb /workdir/btb/btb
COPY benchmark/btb_benchmark /workdir/btb_benchmark/btb_benchmark
COPY benchmark/notebooks /workdir/notebooks

WORKDIR /workdir/notebooks
CMD jupyter notebook --ip 0.0.0.0 --allow-root --NotebookApp.token=''
