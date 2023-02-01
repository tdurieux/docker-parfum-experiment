FROM condaforge/mambaforge

COPY . conda-lock/

RUN mamba install pip -y
RUN pip install --no-cache-dir conda-lock/.

CMD conda-lock install \
    --name test \
    --mamba \
    conda-lock/test.lock
