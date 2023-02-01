from python:3

# Install dependencies
RUN pip install --no-cache-dir wit \
 && pip install --no-cache-dir PyYaml \
 && pip install --no-cache-dir -U flask-cors \
 && pip install --no-cache-dir bs4 \
 && pip install --no-cache-dir ufal.morphodita

ADD . /alquist

WORKDIR /alquist

CMD ["python3","-u", "main.py"]

# Expose port
EXPOSE 5000

