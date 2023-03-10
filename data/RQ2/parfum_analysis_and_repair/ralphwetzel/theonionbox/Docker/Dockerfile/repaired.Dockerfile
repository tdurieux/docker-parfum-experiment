FROM python:3.6

EXPOSE 8080

RUN pip install --no-cache-dir pip --upgrade && pip install --no-cache-dir theonionbox

COPY theonionbox.cfg /usr/local/lib/python3.6/site-packages/theonionbox

ENTRYPOINT ["/usr/local/bin/theonionbox", "-c", "/usr/local/lib/python3.6/site-packages/theonionbox/theonionbox.cfg"]
