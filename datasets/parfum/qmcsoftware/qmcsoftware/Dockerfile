FROM python:3.7.0
WORKDIR /code
RUN pip install numpy==1.21.1
RUN pip install scipy==1.4.1
COPY qmcpy/ ./qmcpy/
COPY setup.py .
RUN pip install -e .
