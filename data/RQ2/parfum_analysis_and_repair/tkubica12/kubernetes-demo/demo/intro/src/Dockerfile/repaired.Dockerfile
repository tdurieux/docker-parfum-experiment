FROM python:3

WORKDIR /app
COPY . ./
RUN pip3 install --no-cache-dir -r requirements.txt

ENV PORT=8080
EXPOSE 8080
CMD [ "python", "./application.py" ]