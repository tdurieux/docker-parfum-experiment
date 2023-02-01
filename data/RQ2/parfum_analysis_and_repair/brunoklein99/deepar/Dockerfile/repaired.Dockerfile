FROM pytorch
COPY . .
RUN pip install --no-cache-dir pandas
ENTRYPOINT python -u train.py > out.txt