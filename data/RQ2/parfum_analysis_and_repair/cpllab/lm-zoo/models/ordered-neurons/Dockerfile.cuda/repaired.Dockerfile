FROM continuumio/miniconda3:latest

# Root of model directory relative to build context.
ARG MODEL_ROOT=models/ordered-neurons

RUN conda install pytorch=0.4.1 cuda92 -c pytorch
RUN conda install nltk

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

# Add test dependencies.
RUN pip install --no-cache-dir nose rednose
ENV NOSE_REDNOSE 1

# Set up output volume.
VOLUME /out

# Copy in source code.
RUN git clone git://github.com/yikangshen/Ordered-Neurons /opt/Ordered-Neurons \
        && cd /opt/Ordered-Neurons \
        && git checkout 46d63cd

# Build arguments provide SSH keys for accessing private CPL data.
ARG CPL_SSH_PRV_KEY
RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no" >> /root/.ssh/config \
      && echo "$CPL_SSH_PRV_KEY" > /root/.ssh/id_rsa \
      && chmod 600 /root/.ssh/id_rsa

# Copy in model parameters.
RUN scp -o "StrictHostKeyChecking=no" \
      cpl@45.79.223.150:/home/cpl/ordered-neurons/models/fredashi-20190919/{1234.pt,corpus.data} \
      /opt/Ordered-Neurons

# Remove SSH information.
RUN rm -rf /root/.ssh

# Copy in custom file for surprisal evaluation
COPY ${MODEL_ROOT}/get_surprisals.py /opt/Ordered-Neurons/get_surprisals.py

# Copy in shared tests.
COPY test.py /opt/test.py

# Copy external-facing scripts
COPY ${MODEL_ROOT}/bin /opt/bin
ENV PATH "/opt/bin:${PATH}"

WORKDIR /opt/bin
