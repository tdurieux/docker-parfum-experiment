FROM tensorflow/tensorflow:0.11.0rc2

RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir prettytensor
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir plotly
RUN pip install --no-cache-dir pdoc
RUN pip install --no-cache-dir mako
RUN pip install --no-cache-dir markdown
RUN pip install --no-cache-dir decorator==4.0.9
RUN pip install --no-cache-dir tflearn
RUN pip install --no-cache-dir asq==1.2.1
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir pytest-sugar
RUN pip install --no-cache-dir fn
