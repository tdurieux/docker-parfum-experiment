FROM ubuntu

    # Use a fixed apt-get repo to stop intermittent failures due to flaky httpredir connections,
    # as described by Lionel Chan at http://stackoverflow.com/a/37426929/5881346

RUN sed -i "s/httpredir.debian.org/debian.uchicago.edu/" /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -y build-essential python-pip apt-utils git cmake && \
    pip install --no-cache-dir pandas numpy scipy && \
    cd /usr/local/src && \
    pip install --no-cache-dir tensorflow && \

    cd /usr/local/src && mkdir xgboost && cd xgboost && \
    git lo e --depth 1 --rec rs ve https://github.com/d lc \
    make && cd python-pac ag  && python se && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade numpy dill h5py scikit-learn scipy python-dateutil pandas pathos keras coveralls nose lightgbm tabulate imblearn sklearn-deap2 catboost

# To update this image and upload it:
# Build the image (docker build .), and give it two separate tags (latest, and a version number)
# docker build --no-cache -t climbsrocks/auto_ml_tests:0.0.10 -t climbsrocks/auto_ml_tests:latest .
# docker push climbsrocks/auto_ml_tests:latest
# docker push climbsrocks/auto_ml_tests:0.0.10
