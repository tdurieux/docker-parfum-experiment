## Build our base image with all requirements installed via conda
FROM continuumio/miniconda3:4.5.11 as bioconda_base

# Install gnupg via Debian - the conda-forge one is broken
RUN apt-get update && apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;

# Install requirements
COPY ./bioconda_utils/bioconda_utils-requirements.txt /tmp/requirements.txt
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    { conda config --remove repodata_fns current_repodata.json || true ; } && \
    conda config --prepend repodata_fns repodata.json && \
    echo nomkl >> /tmp/requirements.txt && \
    echo binutils >> /tmp/requirements.txt && \
    conda install -y --file /tmp/requirements.txt && \
    echo Cleaning out to minimize space ... && \
    (find /opt/conda -print0 | xargs -0 strip --strip-unneeded 2>/dev/null || true) && \
    conda remove binutils && \
    conda clean -y --all && \
    rm -rf /opt/conda/pkgs && \
    rm -rf /opt/conda/share/{man,doc} && \
    ls -d /opt/conda/share/locale/* | grep -v en_US | xargs rm -rf && \
    find /opt/conda/ -name __pycache__ | xargs rm -rf && \
    find /opt/conda -name \*.a -delete


## Use base image to build wheel from bioconda-utils
FROM bioconda_base as builder
COPY . /tmp/repo
WORKDIR /wheels
RUN pip wheel /tmp/repo


## Install wheel from builder image into base image
FROM bioconda_base
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir -f /wheels bioconda_utils
CMD PYTHONUNBUFFERED=1 gunicorn bioconda_utils.bot.web:start_with_celery \
    --worker-class aiohttp.worker.GunicornWebWorker --bind 0.0.0.0:$PORT

