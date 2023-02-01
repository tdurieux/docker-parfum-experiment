From python:3.7

RUN apt-get update
RUN apt-get -y upgrade

RUN apt -y --no-install-recommends install libblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install rename && rm -rf /var/lib/apt/lists/*;

WORKDIR /
ENV SCILPY_VERSION="master"
RUN wget https://github.com/scilus/scilpy/archive/${SCILPY_VERSION}.zip
RUN unzip ${SCILPY_VERSION}.zip
RUN mv scilpy-${SCILPY_VERSION} scilpy

WORKDIR /scilpy
RUN pip install --no-cache-dir -e .

RUN sed -i '41s/.*/backend : Agg/' /usr/local/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc
