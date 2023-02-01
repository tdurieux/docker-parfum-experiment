FROM python:3

RUN pip install --no-cache-dir pandas && \
    pip install --no-cache-dir numpy && \
    pip install --no-cache-dir PyYAML && \
    pip install --no-cache-dir matplotlib && \
    pip install --no-cache-dir pyyaml

RUN mkdir /src
COPY . /src

CMD python /src/numpy-sum.py
