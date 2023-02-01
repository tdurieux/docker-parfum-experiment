FROM python:3.7

ARG PIP_NO_CACHE_DIR=True

# install build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY ./ .

RUN pip install --no-cache-dir .

CMD python -c "import mrptlib; print('MRPT has been installed')"
