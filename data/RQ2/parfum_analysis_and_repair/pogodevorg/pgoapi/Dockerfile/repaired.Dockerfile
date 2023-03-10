FROM python:3-onbuild

COPY ./pgoapi /pgoapi
COPY ./pokecli.py /pokecli.py

RUN for r in `cat requirements.txt`; do pip install --no-cache-dir $r; done

ENTRYPOINT [ "python", "/pokecli.py" ]
