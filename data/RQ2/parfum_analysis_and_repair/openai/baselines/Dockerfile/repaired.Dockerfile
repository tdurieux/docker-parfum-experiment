FROM python:3.6

RUN apt-get -y update && apt-get -y --no-install-recommends install ffmpeg && rm -rf /var/lib/apt/lists/*;
# RUN apt-get -y update && apt-get -y install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake python-opencv

ENV CODE_DIR /root/code

COPY . $CODE_DIR/baselines
WORKDIR $CODE_DIR/baselines

# Clean up pycache and pyc files
RUN rm -rf __pycache__ && \
    find . -name "*.pyc" -delete && \
    pip install --no-cache-dir 'tensorflow < 2' && \
    pip install --no-cache-dir -e .[test]


CMD /bin/bash
