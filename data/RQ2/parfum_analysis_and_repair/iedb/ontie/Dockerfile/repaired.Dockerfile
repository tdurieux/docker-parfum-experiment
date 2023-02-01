FROM obolibrary/odkfull

COPY requirements.txt /tools/ontie-requirements.txt
RUN pip install --no-cache-dir -r /tools/ontie-requirements.txt

RUN apt-get install --no-install-recommends -y aha && rm -rf /var/lib/apt/lists/*;
