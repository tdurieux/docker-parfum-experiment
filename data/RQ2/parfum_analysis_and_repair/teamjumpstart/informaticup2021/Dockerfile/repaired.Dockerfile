FROM python:3.8.6

WORKDIR /spe_ed

# Install dependencies
ENV PIP_NO_CACHE_DIR=false
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc gfortran libopenblas-dev liblapack-dev && \
    pip install --no-cache-dir -U pip pipenv Cython && rm -rf /var/lib/apt/lists/*;
COPY ["Pipfile", "Pipfile.lock", "./"]
RUN pipenv install --system --deploy --ignore-pipfile

# Copy code
COPY . ./

# Run unit tests
RUN python -m unittest discover -s './tests' -p '*_test.py'

# Entry point
ENTRYPOINT ["python", "./main.py" ]
