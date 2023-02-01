FROM $com.sap.python27
RUN apt-get install --no-install-recommends python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyarrow pandas