FROM python:3.7
RUN apt-get update
RUN apt-get install --no-install-recommends -y make software-properties-common curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends -y npm libldap2-dev libsasl2-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pip==20.0.2
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir coveralls bandit
WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir "file://`pwd`#egg=lemur[dev]"
RUN pip install --no-cache-dir "file://`pwd`#egg=lemur[tests]"
