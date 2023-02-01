FROM gorialis/discord.py:alpine-master

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "run.py"]
