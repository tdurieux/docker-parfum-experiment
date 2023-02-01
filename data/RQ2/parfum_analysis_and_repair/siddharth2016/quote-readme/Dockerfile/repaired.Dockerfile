FROM python:3.7

# Install dependencies.
ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD quotes/quotes.txt /quotes/quotes.txt
ADD funfacts/funfacts.txt /funfacts/funfacts.txt

# Copy code.
ADD main.py /main.py

CMD ["python", "/main.py"]