FROM b.gcr.io/tensorflow/tensorflow:latest
MAINTAINER Vincent Vanhoucke <vanhoucke@google.com>
RUN pip install --no-cache-dir scikit-learn
ADD *.ipynb /notebooks/
WORKDIR /notebooks
CMD ["/run_jupyter.sh"]
