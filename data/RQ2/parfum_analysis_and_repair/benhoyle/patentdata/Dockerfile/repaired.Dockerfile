FROM ubuntu

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    python3 \
    python3-numpy \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir tensorflow

RUN pip3 install --no-cache-dir keras

RUN pip3 install --no-cache-dir gensim

RUN pip3 install --no-cache-dir jupyter

RUN pip3 install --no-cache-dir pandas

RUN pip3 install --no-cache-dir matplotlib

#RUN pip3 install patentdata>=0.0.7

ENV INSTALL_PATH /patentdata
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .
RUN pip install --no-cache-dir --editable .

RUN python3 -m nltk.downloader punkt && python3 -m nltk.downloader stopwords

EXPOSE 8888

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py

#ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook", "--no-browser", "--allow-root"]
