FROM python:2.7
RUN pip install --no-cache-dir prometheus_client
RUN apt-get update && apt-get install --no-install-recommends -y ipmitool && rm -rf /var/lib/apt/lists/*;
COPY ipmi_exporter.py /

# Set environment variables
ENV TARGET_IPS ""

EXPOSE 8000
CMD ["python", "ipmi_exporter.py"]