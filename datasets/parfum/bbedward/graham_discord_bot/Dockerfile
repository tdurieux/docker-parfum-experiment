FROM python:3.7

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --trusted-host pypi.org --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "bot.py"]