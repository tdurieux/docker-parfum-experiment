FROM platipy/platipy

COPY requirements-radiomics.txt requirements-radiomics.txt

RUN pip install --no-cache-dir -r requirements-radiomics.txt

COPY . .

ENV FLASK_APP service.py
