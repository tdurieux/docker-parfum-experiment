FROM pytorch/pytorch:latest
RUN mkdir app
WORKDIR /app
COPY lib ./lib
COPY imagenet/src ./
RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x *
# CMD [ "python3", "main.py" ]