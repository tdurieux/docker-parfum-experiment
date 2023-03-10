FROM networkml
LABEL maintainer="Charlie Lewis <clewis@iqt.org>"

RUN apt-get update && apt-get install --no-install-recommends -y gcc rabbitmq-server && \
    rm -rf /var/cache && \
    pip3 install --no-cache-dir -r test-requirements.txt && rm -rf /var/lib/apt/lists/*;
RUN jupyter nbconvert --ExecutePreprocessor.timeout=300 --to notebook --execute notebooks/networkml_exploration.ipynb --Application.log_level=DEBUG
ENTRYPOINT ["pytest"]
CMD ["-l", "-s", "-v", "-nauto", "--cov=tests/", "--cov=networkml/", "--cov-report", "term-missing", "-c", ".coveragerc", "--rabbitmq-port=5672"]
