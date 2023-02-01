FROM python:3.7.3-stretch
WORKDIR /bionitio
COPY . .

# Install the python package (and executable)
RUN pip3 install --no-cache-dir .

# Override some of the dependencies with the hard-coded versions
RUN pip3 install --no-cache-dir -r requirements-dev.txt
