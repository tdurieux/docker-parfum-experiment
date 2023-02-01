RUN apt-get update && \
  apt-get install --no-install-recommends -y libsndfile-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy==1.16.0
RUN pip install --no-cache-dir "torch>=1.6.0,<1.7.0"
