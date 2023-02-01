FROM gorialis/discord.py
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -Ur requirements.txt
CMD ["python", "-u", "run.py"]
