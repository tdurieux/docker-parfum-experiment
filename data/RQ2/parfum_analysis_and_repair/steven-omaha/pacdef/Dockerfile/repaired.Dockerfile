FROM python:latest

RUN pip install --no-cache-dir pytest
WORKDIR /pytest
ADD pacdef.py test_pacdef.py /pytest/

RUN pytest -v --color=yes

