FROM python:3.10-slim
RUN pip install --no-cache-dir requests
RUN apt-get update && apt-get install --no-install-recommends -y libffi-dev && rm -rf /var/lib/apt/lists/*;

COPY hik.py /hik.py
COPY hcnetsdk.py /hcnetsdk.py
COPY lib /lib

CMD [ "python3", "hik.py" ]
