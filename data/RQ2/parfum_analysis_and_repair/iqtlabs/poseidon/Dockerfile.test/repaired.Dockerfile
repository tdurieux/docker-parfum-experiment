FROM poseidon:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y tshark gcc g++ && \
  pip3 install --no-cache-dir -r tests/requirements.txt && \
  apt-get purge -y gcc g++ && apt -y autoremove --purge && rm -rf /var/cache/* /root/.cache/* && rm -rf /var/lib/apt/lists/*;

# needed for workers, since it's not a package
ENV PYTHONPATH /poseidon:$PYTHONPATH

RUN cat .coveragerc
CMD py.test -v -vv --cov-report term-missing --cov=. --cov=poseidon_core --cov=poseidon_api --cov=poseidon_cli -c .coveragerc && \
    pytype src/*/*/*py workers/*py src/core/*/*/*py src/core/*/*/*/*py && \
    ./tests/api_smoke_test.sh
