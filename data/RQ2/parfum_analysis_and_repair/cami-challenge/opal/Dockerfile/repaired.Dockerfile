FROM python:3.7.12-slim

ADD *.py /usr/local/bin/
ADD src /usr/local/bin/src
ADD src/utils /usr/local/bin/src/utils
ADD requirements /requirements
RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN head -n 1 /requirements/default.txt | xargs pip install
RUN pip install --no-cache-dir -r /requirements/default.txt
RUN apt-get remove --purge -y gcc && apt-get autoremove -y
