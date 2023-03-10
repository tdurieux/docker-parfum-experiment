FROM umccr/umccrise:0.10.6

# Install source
COPY umccrise umccrise/umccrise
COPY scripts umccrise/scripts
COPY vendor umccrise/vendor
COPY setup.py umccrise/setup.py
RUN pip install --no-cache-dir -e umccrise
