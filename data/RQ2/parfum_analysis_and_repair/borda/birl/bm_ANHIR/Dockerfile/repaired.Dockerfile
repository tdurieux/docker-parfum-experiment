#FROM ubuntu:16.04
FROM python:3.7-slim-stretch
#FROM borda/docker_python-opencv-ffmpeg:py3

LABEL maintainer="jiri.borovec@fel.cvut.cz"

# Install packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        git>=2.0 \
        gcc>=5.1 \
        tk-dev>=8.5 \
#        python-dev \
#        python-tk \
#        pkg-config \
# not needed as no images are loade/saved
#        openslide-tools \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \

# Setting according Grand-Challenges
    groupadd -r evaluator && \
    useradd -m --no-log-init -r -g evaluator evaluator && \
    mkdir -p /opt/evaluation /input /output && \
    chown evaluator:evaluator /opt/evaluation /input /output \
    && \

# for Ubuntu instalation
#    wget https://bootstrap.pypa.io/get-pip.py --progress=bar:force:noscroll && python get-pip.py && \

# neeeded for openslide installing failer
    pip install --no-cache-dir "setuptools<46.0" && \
# Install BIRL package
    pip install --upgrade --force-reinstall --no-cache-dir git+https://github.com/Borda/BIRL.git>=0.2.4 && \
#    pip install --upgrade --force-reinstall --no-cache-dir git+https://github.com/Borda/BIRL.git@devel && \

# Clean image from not needed packages
    apt-get -y remove \
        gcc \
        git \
    && \
    apt-get autoremove -y && \
    apt-get clean \
    && \

    python -c "import birl; print(birl.__version__)"

USER evaluator
WORKDIR /opt/evaluation

ENV PATH="/home/evaluator/.local/bin:${PATH}"

# Coppy required files
COPY --chown=evaluator:evaluator ./evaluate_submission.py /opt/evaluation/
COPY --chown=evaluator:evaluator ./dataset_ANHIR/dataset_medium.csv /opt/evaluation/dataset.csv
COPY --chown=evaluator:evaluator ./dataset_ANHIR/computer-performances_cmpgrid-71.json /opt/evaluation/computer-performances.json
COPY --chown=evaluator:evaluator ./dataset_ANHIR/landmarks_user_phase2 /opt/evaluation/lnds_provided
COPY --chown=evaluator:evaluator ./dataset_ANHIR/landmarks_all /opt/evaluation/lnds_reference

# Define execution
ENTRYPOINT "python" "evaluate_submission.py" \
    "--path_experiment" "/input" \
    "--path_table" "/opt/evaluation/dataset.csv" \
    "--path_dataset" "/opt/evaluation/lnds_provided" \
    "--path_reference" "/opt/evaluation/lnds_reference" \
    "--path_comp_bm" "/opt/evaluation/computer-performances.json" \
    "--path_output" "/output" \
    "--min_landmarks" 1.0
