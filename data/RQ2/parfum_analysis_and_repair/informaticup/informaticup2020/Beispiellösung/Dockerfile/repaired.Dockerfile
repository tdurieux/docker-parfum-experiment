FROM python
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ./example.py
