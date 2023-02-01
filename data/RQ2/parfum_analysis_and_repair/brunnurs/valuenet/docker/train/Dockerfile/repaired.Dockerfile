FROM nvcr.io/nvidia/pytorch:20.12-py3

COPY download_nltk.py /tmp

RUN apt update
RUN apt-get -y --no-install-recommends install default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;


# the following lines are necessary to remote debug into the docker via SSH.
# make sure you also start the ssh service at the entrypoint!
EXPOSE 22

RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd

ADD authorized_keys /tmp/
ADD known_hosts /tmp/
RUN mkdir -p /root/.ssh \
    && mv /tmp/authorized_keys /root/.ssh/authorized_keys \
    && mv /tmp/known_hosts /root/.ssh/known_hosts \
    && chown root:root /root/.ssh/*\
    && rm -rf /tmp/authorized_keys

# Don't just use the requirements file and install torch etc.... the nvidia image already
# comes with a pre-installed torch etc, so installing another torch/pytorch (and also the transitive torch dependency of transformers for example)
# will cause quite a bit of trouble.
RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir pattern
RUN pip install --no-cache-dir transformers
RUN pip install --no-cache-dir pytictoc
RUN pip install --no-cache-dir wandb
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir textdistance
RUN pip install --no-cache-dir word2number
RUN pip install --no-cache-dir sqlparse
# in contrary to the pipfile we need some binaries for postgres too.
RUN pip install --no-cache-dir psycopg2-binary

RUN wandb login c9bac4494d41935972b1da58001870aec716e3bb

RUN python /tmp/download_nltk.py
RUN python -m spacy download en_core_web_sm

ENV PYTHONPATH /workspace

WORKDIR /workspace

ENTRYPOINT service ssh restart && bash
