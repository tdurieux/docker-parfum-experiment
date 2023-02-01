FROM python:3-alpine

WORKDIR mdv
COPY . .
RUN pip install --no-cache-dir -e .

ENTRYPOINT [ "mdv" ]
