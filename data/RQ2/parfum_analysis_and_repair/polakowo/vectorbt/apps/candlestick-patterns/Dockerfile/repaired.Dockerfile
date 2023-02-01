FROM python:3.8-slim

RUN apt-get -y update && apt-get -y --no-install-recommends install gcc curl make && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
# Required by TA-Lib and numba
RUN pip install --no-cache-dir numpy >=1.19.4

RUN curl -f -O https://netcologne.dl.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz \
    && tar -xzf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
    && make \
    && make install \
    && cd .. && rm ta-lib-0.4.0-src.tar.gz

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY assets ./assets
COPY app.py .

CMD ["python", "app.py"]