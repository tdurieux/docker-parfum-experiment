FROM continuumio/miniconda3

# For Slackbot Dockerfile

ENTRYPOINT []
CMD [ "/bin/bash" ]

# Remove (large file sizes) MKL optimizations.
RUN conda install -y nomkl

# matplotlib issue
# https://github.com/ContinuumIO/anaconda-issues/issues/1068
RUN conda install -y numpy scipy scikit-learn matplotlib pandas

ADD ./requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -qr /tmp/requirements.txt

# Add our code
RUN apt-get install --no-install-recommends -y fonts-ipafont fonts-ipaexfont && rm -rf /var/lib/apt/lists/*;
ADD ./karura /opt/karura/
WORKDIR /opt/karura/

CMD python run_server.py
