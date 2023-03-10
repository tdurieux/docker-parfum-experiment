FROM library/python:3.6
WORKDIR /opt/fairing

# First copy setup.py and do a pip install -e to
# only install dependencies. This will make
# subsequent docker builds much faster
COPY setup.py /opt/fairing/
RUN pip install --no-cache-dir -e .

COPY ./ /opt/fairing
RUN python ./setup.py install