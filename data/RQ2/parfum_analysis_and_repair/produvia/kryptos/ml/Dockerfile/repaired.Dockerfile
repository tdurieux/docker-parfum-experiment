FROM python:3.6 as base

# install xgboost library
RUN git clone --recursive https://github.com/dmlc/xgboost \
    && cd xgboost; make -j4

# install TA_LIB library and other dependencies
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install libfreetype6-dev libpng-dev libopenblas-dev liblapack-dev gfortran \
    && curl -f -L -O http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -zxf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
    && make \
    && make install \
    && rm -rf ta-lib* && rm ta-lib-0.4.0-src.tar.gz && rm -rf /var/lib/apt/lists/*;

FROM base as builder

RUN mkdir /install
WORKDIR /install
# copy only the requirements to prevent rebuild for any changes
COPY requirements.txt /requirements.txt

# ensure numpy installed before ta-lib, matplotlib, etc
RUN pip install --no-cache-dir 'numpy==1.14.3'
RUN pip install --no-cache-dir -r /requirements.txt


# matplotlib config (used by benchmark)
RUN mkdir -p /root/.config/matplotlib
RUN echo "backend : Agg" > /root/.config/matplotlib/matplotlibrc


FROM builder

COPY --from=builder /root/.cache /root/.cache
COPY --from=builder /requirements.txt /ml/requirements.txt
RUN pip install --no-cache-dir -r /ml/requirements.txt && rm -rf /root/.cache


# Above lines represent the dependencies
# below lines represent the actual app
# Only the actual app should be rebuilt upon changes
COPY . /ml

WORKDIR /ml
ENTRYPOINT python worker.py
