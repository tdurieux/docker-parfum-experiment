FROM python:3.6

RUN apt update && apt install --no-install-recommends graphviz -y && rm -rf /var/lib/apt/lists/*;

COPY tests/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app
ENV PYTHONPATH=/app
# ADD . .

# CMD [ "ptw","--","-sv" ]
CMD [ "/bin/bash" ]