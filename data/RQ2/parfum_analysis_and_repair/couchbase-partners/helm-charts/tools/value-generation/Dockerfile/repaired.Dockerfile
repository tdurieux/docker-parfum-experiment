FROM python:3

WORKDIR /source

# Add the python scripts
COPY *.py ./bin/
COPY requirements.txt ./config/
RUN pip install --no-cache-dir -r config/requirements.txt

ENTRYPOINT ["python3", "/source/bin/gen.py"]