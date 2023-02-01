FROM tensorflow/tensorflow:1.15.0-py3

WORKDIR /tf
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# For onnx2keras compatibility issue
ENV TF_KERAS=1 
ENV TF_CPP_MIN_LOG_LEVEL=3

COPY Examples/dlconvert_examples/dlconvert_requirements.txt /tf/
COPY requirements.txt /tf/

RUN pip install --no-cache-dir -r dlconvert_requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY src/aup /tf/src/aup
COPY tests/dlconvert /tf/tests/dlconvert
COPY setup.py README.md /tf/
RUN cd /tf/ && python setup.py -q install
RUN cd /tf/tests/dlconvert/data && ./prepare_docker.sh

VOLUME /tf/htmlcov

CMD coverage run --source dlconvert -m pytest tests; coverage html