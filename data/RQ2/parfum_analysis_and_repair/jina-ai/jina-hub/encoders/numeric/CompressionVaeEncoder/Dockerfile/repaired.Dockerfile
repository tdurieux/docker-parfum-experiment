FROM jinaai/jina:1.3.0

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

RUN python train_default_model.py && \
rm -rf 'data'

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]