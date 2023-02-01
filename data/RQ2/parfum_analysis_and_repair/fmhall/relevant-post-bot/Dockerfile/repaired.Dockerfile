FROM jackton1/alpine-python3-numpy-pandas

COPY . app
RUN pip3 install --no-cache-dir -r app/requirements.txt

WORKDIR /app/src/

ENTRYPOINT ["python3", "main.py"]
