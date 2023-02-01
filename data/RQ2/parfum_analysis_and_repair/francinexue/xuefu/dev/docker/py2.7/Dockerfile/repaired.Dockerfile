FROM python:2.7
RUN pip install --no-cache-dir pandas mock nose
RUN pip install --no-cache-dir lxml requests
RUN pip install --no-cache-dir tushare pymongo sqlalchemy eventlet
COPY ta-lib-0.4.0-src.tar.gz gmsdk-2.9.5-py2-none-any.whl /
RUN tar -xvzf ta-lib-0.4.0-src.tar.gz && rm ta-lib-0.4.0-src.tar.gz
RUN cd ta-lib && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install
RUN pip install --no-cache-dir TA-Lib
RUN pip install --no-cache-dir gmsdk-2.9.5-py2-none-any.whl
RUN rm -rf ta-lib* gmsdk-2.9.5-py2-none-any.whl
RUN pip install --no-cache-dir scipy ws4py pytz tornado tweepy
RUN pip install --no-cache-dir peakutils matplotlib pyalgotrade
RUN pip install --no-cache-dir scipy statsmodels
RUN pip install --no-cache-dir --no-deps astropy
#RUN apt-get install libfreetype6-dev
RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr libboost-python1.55-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pillow demjson
RUN pip install --no-cache-dir easytrader
COPY libthostmduserapi.so libthosttraderapi.so /usr/lib/x86_64-linux-gnu/
