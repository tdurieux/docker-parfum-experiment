FROM ravwojdyla/snakebite_test:base

ADD . /snakebite
WORKDIR /snakebite
RUN pip install --no-cache-dir -r requirements-dev.txt
