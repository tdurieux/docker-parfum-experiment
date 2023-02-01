FROM python

COPY . ./Valorant-Store

WORKDIR ./Valorant-Store

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "./bot.py"]
