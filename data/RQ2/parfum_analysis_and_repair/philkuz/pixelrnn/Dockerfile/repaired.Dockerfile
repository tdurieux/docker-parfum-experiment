FROM gcr.io/tensorflow/tensorflow
RUN apt-get update && apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir tqdm
RUN git clone https://github.com/philkuz/PixelRNN.git /notebooks/PixelRNN
WORKDIR "/notebooks"
CMD ["/run_jupyter.sh"]
