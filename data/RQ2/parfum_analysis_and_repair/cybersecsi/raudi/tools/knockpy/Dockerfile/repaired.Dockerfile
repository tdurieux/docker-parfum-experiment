ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG KNOCKPY_DOWNLOAD_URL

# Content
WORKDIR /knockpy
ADD $KNOCKPY_DOWNLOAD_URL knockpy.tar.gz
RUN tar -xvf knockpy.tar.gz -C /knockpy --strip-components=1 && rm knockpy.tar.gz
RUN pip install --no-cache-dir -r /knockpy/requirements.txt
ENTRYPOINT ["python", "/knockpy/knockpy.py"]