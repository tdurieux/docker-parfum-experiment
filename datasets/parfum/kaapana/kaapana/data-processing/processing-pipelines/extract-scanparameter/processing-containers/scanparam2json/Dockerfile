FROM local-only/base-python-alpine:0.1.0

LABEL IMAGE="scanparam2json"
LABEL VERSION="0.1.0"
LABEL CI_IGNORE="True"

COPY files/scanparam2json.py /kaapanasrc/

CMD ["python3","-u","/kaapanasrc/scanparam2json.py"]