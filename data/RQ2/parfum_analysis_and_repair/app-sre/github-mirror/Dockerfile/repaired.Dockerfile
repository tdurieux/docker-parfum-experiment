FROM        registry.access.redhat.com/ubi8/python-39

WORKDIR     /ghmirror

COPY        . ./

RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir gunicorn

ENTRYPOINT  ["gunicorn", "ghmirror.app:APP"]
CMD         ["--workers", "1", "--threads",  "8", "--bind", "0.0.0.0:8080"]
