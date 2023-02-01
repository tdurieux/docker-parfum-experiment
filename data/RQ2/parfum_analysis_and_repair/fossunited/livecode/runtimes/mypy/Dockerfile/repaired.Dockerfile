FROM fossunited/falcon-python:3.9
RUN pip install --no-cache-dir mypy
ADD modes/mypy.sh /opt/modes/
