FROM ddidier/sphinx-doc:1.8.5-5

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
