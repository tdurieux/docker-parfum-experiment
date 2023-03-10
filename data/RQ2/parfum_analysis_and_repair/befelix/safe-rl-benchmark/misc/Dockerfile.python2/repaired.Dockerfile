FROM continuumio/miniconda

ENV TF_CPP_MIN_LOG_LEVEL=2

# Install build essentials and clean up
RUN apt-get update --quiet \
  && apt-get install -y --no-install-recommends --quiet build-essential \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Fix matlab issues.
RUN apt-get install --no-install-recommends -y --quiet libfreetype6-dev pkg-config libpng12-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Update conda, install packages, and clean up
RUN conda update conda --yes --quiet \
  && conda install python=2.7 pip numpy scipy nose --yes --quiet \
  && conda clean --yes --all \
  && hash -r

# Get the requirements files (seperate from the main body)
COPY requirements.txt requirements_dev.txt /code/

# Install requirements and clean up
RUN pip --no-cache-dir install -r code/requirements.txt \
    && rm -rf /root/.cache

# Install dev requirements and clean up
RUN pip --no-cache-dir install -r code/requirements_dev.txt \
  && rm -rf /root/.cache

# Install extra python2 requirements
RUN pip --no-cache-dir install futures multiprocessing \
  && rm -rf /root/.cache

# Install SafeOpt
RUN git clone https://github.com/befelix/SafeOpt.git \
  && cd SafeOpt \
  && python setup.py install \
  && rm -rf /SafeOpt

# Copy the main code
COPY . /code
RUN cd /code && python setup.py develop

WORKDIR /code
