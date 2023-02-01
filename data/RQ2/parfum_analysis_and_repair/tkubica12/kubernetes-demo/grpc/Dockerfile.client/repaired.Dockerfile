FROM python:3

WORKDIR /app
COPY . ./
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 50001
CMD [ "python", "./greeter_client.py" ]