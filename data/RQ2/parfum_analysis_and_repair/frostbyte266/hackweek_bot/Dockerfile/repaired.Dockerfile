FROM python:3.7

RUN pip install --no-cache-dir discord.py aiohttp networkx pandas matplotlib

COPY . .

CMD ["python", "main.py"]
