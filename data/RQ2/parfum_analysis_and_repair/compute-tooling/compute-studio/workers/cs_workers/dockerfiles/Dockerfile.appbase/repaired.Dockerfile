ARG TAG
FROM continuumio/miniconda3:master

RUN apt-get update && apt install --no-install-recommends libgl1-mesa-glx --yes && rm -rf /var/lib/apt/lists/*;

ARG BRANCH="dev"
RUN echo ${BRANCH}

RUN conda config --append channels conda-forge && \
    conda install "python>=3.7" pip && \
    pip install --no-cache-dir gunicorn \
    "cs-kit>=1.16.9" \
    pytest \
    cs-jobs

WORKDIR /home
