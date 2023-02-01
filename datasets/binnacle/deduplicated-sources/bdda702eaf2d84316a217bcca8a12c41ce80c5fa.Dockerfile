FROM python:3.5
ADD ./dockerfiles/janeway.sqlite3 /db/janeway.sqlite3
RUN curl https://raw.githubusercontent.com/BirkbeckCTP/janeway/master/requirements.txt > /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
ENTRYPOINT ["/bin/bash"]
