FROM wuvt-site:latest

RUN pip install --no-cache-dir flask_swagger

VOLUME ["/data"]

ENTRYPOINT ["flaskswagger", "wuvt:app", "--out-dir", "/data"]