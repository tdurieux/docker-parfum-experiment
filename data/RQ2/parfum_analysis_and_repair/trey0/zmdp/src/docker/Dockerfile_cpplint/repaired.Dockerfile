FROM python:latest

RUN pip install --no-cache-dir --upgrade --root=/ pip 2>&1 | grep -v "Running pip as root" \
  && pip install --no-cache-dir --root=/ cpplint 2>&1 | grep -v "Running pip as root"

COPY . /zmdp

RUN cd /zmdp/src && make cpplint