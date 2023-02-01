FROM python:3.8
WORKDIR /zest.releaser/
ENV PYTHONPATH=/zest.releaser/
ENV USER=root
RUN pip install --no-cache-dir -U pip setuptools tox && \
    apt-get update && \
    apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
COPY . /zest.releaser/
CMD tox -e py38
