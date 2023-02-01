FROM andyceo/pylibs
COPY ["monitoring-certificate.py", "requirements.txt", "/app/"]
RUN pip3 install --no-cache-dir -r requirements.txt && rm requirements.txt
ENTRYPOINT ["/app/monitoring-certificate.py"]
CMD []
