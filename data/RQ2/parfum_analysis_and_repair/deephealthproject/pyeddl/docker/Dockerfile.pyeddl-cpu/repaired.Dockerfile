FROM dhealth/dev-pyeddl-base-cpu

COPY . /pyeddl
WORKDIR /pyeddl

RUN python3 setup.py install