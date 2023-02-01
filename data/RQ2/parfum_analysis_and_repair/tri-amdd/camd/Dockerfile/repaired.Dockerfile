FROM continuumio/miniconda3

# Activate shell
SHELL ["/bin/bash", "-c"]
ENV PATH="/opt/conda/bin/:$PATH"

RUN mkdir -p /home/camd && \
    conda create -n camd python=3.7 && \
    apt-get update && \
    apt-get -y --no-install-recommends install gcc g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/camd

# Create camd env
ENV PATH="/opt/conda/envs/camd/bin:$PATH"

COPY setup.py requirements.txt /home/camd/

# Install package
RUN source /opt/conda/bin/activate camd && \
    # pip install `grep numpy requirements.txt` && \
    pip install --no-cache-dir -r requirements.txt

COPY camd /home/camd/camd
RUN pip install --no-cache-dir -e .
