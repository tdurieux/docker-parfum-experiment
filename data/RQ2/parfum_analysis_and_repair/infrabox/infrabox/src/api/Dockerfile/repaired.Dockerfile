FROM debian:9.3

RUN apt-get update -y && apt-get install --no-install-recommends -y python python-psycopg2 python-requests python-pip python-flask python-ldap && \
    pip install --no-cache-dir PyJWT jsonschema cryptography flask_restplus eventlet flask_socketio boto3 google-cloud-storage future bcrypt && \
    apt-get remove -y python-pip && rm -rf /var/lib/apt/lists/*;

ENV PYTHONPATH=/

COPY src/api /api
COPY src/pyinfraboxutils /pyinfraboxutils
COPY src/pyinfrabox /pyinfrabox

CMD python /api/server.py
