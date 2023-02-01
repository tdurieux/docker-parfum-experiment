FROM jinaai/jina:1.2.1

COPY . /workspace
WORKDIR /workspace

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytest && pytest tests/ -v -s

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]