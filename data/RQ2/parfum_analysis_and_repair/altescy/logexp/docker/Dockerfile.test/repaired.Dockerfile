FROM python:3.7

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /logexp

COPY setup.py setup.py
COPY logexp/ logexp/
COPY examples/ examples/
COPY tests/ tests/
COPY dev-requirements.txt dev-requirements.txt
COPY pytest.ini pytest.ini
COPY .pylintrc .pylintrc
COPY Makefile Makefile
COPY LICENSE LICENSE

RUN pip install --no-cache-dir -r dev-requirements.txt
RUN python setup.py install
RUN make clean

CMD ["make", "test"]
