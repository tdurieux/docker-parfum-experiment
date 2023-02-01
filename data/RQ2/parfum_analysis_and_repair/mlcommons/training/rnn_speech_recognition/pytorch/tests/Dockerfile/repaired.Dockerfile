FROM nvcr.io/nvidia/pytorch:20.10-py3

COPY tests/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt



WORKDIR /code

CMD bash
