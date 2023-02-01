FROM ubuntu:20.04

RUN apt-get update && apt-get -y --no-install-recommends install git make python3 python3-pip python3-venv sqlite3 vim virtualenvwrapper wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/dbt-sqlite

WORKDIR /root/dbt-sqlite

RUN mkdir -p /tmp/dbt-sqlite-tests

RUN cd /tmp/dbt-sqlite-tests && wget https://github.com/nalgeon/sqlean/releases/download/0.12.2/crypto.so

RUN pip install --no-cache-dir dbt-core~=1.1.0

RUN pip install --no-cache-dir pytest pytest-dotenv dbt-tests-adapter==1.1.0

ENTRYPOINT ["./run_tests.sh"]
