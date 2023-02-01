FROM python:3.9

# Set up code directory
WORKDIR /usr/src/app

# Install Linux dependencies
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY web3 ./web3/
COPY tests ./tests/
COPY ens ./ens/
COPY ethpm ./ethpm/

COPY setup.py .
COPY README.md .

RUN pip install --no-cache-dir -e .[dev]

WORKDIR /code
