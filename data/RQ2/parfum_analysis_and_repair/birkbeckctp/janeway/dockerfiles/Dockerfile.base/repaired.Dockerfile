FROM python:3.8
ADD ./dockerfiles/janeway.sqlite3 /db/janeway.sqlite3
RUN curl -f https://raw.githubusercontent.com/BirkbeckCTP/janeway/master/requirements.txt > /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
ENTRYPOINT ["/bin/bash"]
