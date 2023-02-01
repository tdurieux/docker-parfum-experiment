FROM python:3
RUN pip install --no-cache-dir open-tamil
RUN mkdir /examples
WORKDIR /examples
ADD examples /examples/
