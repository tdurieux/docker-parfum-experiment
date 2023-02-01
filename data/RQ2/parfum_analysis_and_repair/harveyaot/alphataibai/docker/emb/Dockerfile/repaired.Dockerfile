FROM pytorch/pytorch
COPY app /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
