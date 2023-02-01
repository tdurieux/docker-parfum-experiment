# Please run docker build from remoulade main directory

FROM python:3.10

COPY . .
RUN pip install --no-cache-dir -e .[all]
RUN pip install --no-cache-dir -e examples/composition

WORKDIR /examples/composition
CMD composition_worker
