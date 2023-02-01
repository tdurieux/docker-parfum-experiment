FROM python:3.9-alpine3.12

LABEL REGISTRY="local-only"
LABEL IMAGE="base-charts-manager"
LABEL VERSION="0.1.0"
LABEL CI_IGNORE="False"

COPY files/run.py /

CMD ["python3","-u","/run.py"]