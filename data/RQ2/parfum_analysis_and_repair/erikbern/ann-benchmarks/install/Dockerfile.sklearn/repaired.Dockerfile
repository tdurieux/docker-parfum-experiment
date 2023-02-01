FROM ann-benchmarks

RUN pip3 install --no-cache-dir scikit-learn
RUN python3 -c 'import sklearn'
