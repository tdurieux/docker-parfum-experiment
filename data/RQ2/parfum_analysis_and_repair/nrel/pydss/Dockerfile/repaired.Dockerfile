FROM python:3.7.0-slim

RUN apt-get update

# Copy the source code
COPY . /PyDSS

# Change directory to the src folder
WORKDIR /PyDSS

RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir --upgrade pip
# Install the python modules
RUN pip install --no-cache-dir -e .

ENV PYTHONPATH=/PyDSS/PyDSS

EXPOSE 5000/tcp
EXPOSE 9090/tcp

# Change directory to the src folder
CMD [ "pydss", "serve" ]
