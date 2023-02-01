FROM python:3.9-slim
RUN apt-get update && apt-get install --no-install-recommends -y git gcc libhdf5-dev locales && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip setuptools \
 && pip install --no-cache-dir pylint

ADD . /tmp/dustdevil/
WORKDIR /tmp/dustdevil/
RUN pip install --no-cache-dir -e .['test']
CMD ((git diff --name-only origin/master..$GIT_COMMIT) | grep .py$) | xargs -r -n1 pylint -j 0 -f parseable -r no>pylint.log
