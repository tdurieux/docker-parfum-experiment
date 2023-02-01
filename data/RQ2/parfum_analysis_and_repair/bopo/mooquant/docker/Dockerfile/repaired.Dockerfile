ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}
MAINTAINER BoPo <ibopo@126.com>

RUN apt-get update; apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gfortran libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir patsy
RUN pip install --no-cache-dir statsmodels
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir ws4py
RUN pip install --no-cache-dir tornado
RUN pip install --no-cache-dir tweepy
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir retrying

# TA-Lib
RUN cd /tmp; \
	wget https://sourceforge.net/projects/ta-lib/files/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz; \
	tar -xzf ta-lib-0.4.0-src.tar.gz; \
	cd ta-lib; \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make install; \
	cd ..; \
	rm ta-lib-0.4.0-src.tar.gz; \
	rm -rf ta-lib

RUN pip install --no-cache-dir TA-Lib
RUN pip install --no-cache-dir pyalgotrade==0.20
