FROM python:3.7-alpine

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5005

CMD ["python", "meraki_sample_webhook_receiver.py", "-n", "Simulated Network", "-s", "webbie", "-m", "Webbie"]