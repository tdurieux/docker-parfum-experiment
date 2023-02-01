FROM python:3.7.0
WORKDIR /code
RUN pip install --no-cache-dir numpy==1.21.1
RUN pip install --no-cache-dir scipy==1.4.1
COPY qmcpy/ ./qmcpy/
COPY setup.py .
RUN pip install --no-cache-dir -e .
