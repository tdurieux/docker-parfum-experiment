FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# RUN pip install -r requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]