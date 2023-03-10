FROM python:3.5

RUN pip install --no-cache-dir --upgrade pip

COPY /build/amd64-requirements.txt ./

RUN export PIP_DEFAULT_TIMEOUT=100
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir -r amd64-requirements.txt

# Expose the port
EXPOSE 80
EXPOSE 5679

ADD app /app

# Set the working directory
WORKDIR /app

# Run the flask server for the endpoints
CMD python -u iotedge_model.py