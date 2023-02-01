FROM ghcr.io/k105la/pulsetracker/pulsetracker:latest
COPY . ./
RUN pip3 install --no-cache-dir -r requirements.txt
CMD python3 api.py
