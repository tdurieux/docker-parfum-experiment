FROM debian:wheezy

RUN sed -i '1i deb     http://gce_debian_mirror.storage.googleapis.com/ wheezy \
    main' etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y git python-pip python-dev liblapack-dev libatlas-base-dev gfortran libfreetype6-dev libpng12-dev libzmq-dev && \
  easy_install -U distribute && \
  pip install --no-cache-dir -U Cython && \
  pip install --no-cache-dir numpy scipy pandas matplotlib scikit-learn && \
  pip install --no-cache-dir patsy && \
  pip install --no-cache-dir statsmodels && \
  pip install --no-cache-dir python-gflags google-api-python-client && \
  pip install --no-cache-dir openpyxl && \
  pip install --no-cache-dir pyzmq jinja2 tornado && \
  pip install --no-cache-dir yt && \
  pip install --no-cache-dir bokeh && \
  pip install --no-cache-dir ipython[notebook] && \
  apt-get remove -y --purge python-dev libatlas-base-dev gfortran && \
  apt-get autoremove -y --purge && \
  apt-get clean -y && rm -rf /var/lib/apt/lists/*; # Install libraries: pip, python dev, vitualenv, zmq, ...
















ADD / /colaboratory/

WORKDIR /colaboratory

# Install coLaboratory
RUN pip install --no-cache-dir -r requirements.txt

# Run
CMD python -m colaboratory --ip='*'
