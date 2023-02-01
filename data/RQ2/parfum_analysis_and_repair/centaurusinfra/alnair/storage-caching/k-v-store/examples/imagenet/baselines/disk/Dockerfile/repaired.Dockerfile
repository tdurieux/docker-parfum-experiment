FROM pytorch/pytorch:latest
RUN mkdir app
WORKDIR /app
COPY main.py ./
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x *
# CMD [ "python3", "main.py" ]
CMD [ "bash" ]