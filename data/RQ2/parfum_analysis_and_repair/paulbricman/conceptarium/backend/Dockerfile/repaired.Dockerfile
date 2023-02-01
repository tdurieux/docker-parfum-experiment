FROM ubuntu
EXPOSE 8000
WORKDIR /app
RUN apt update
RUN apt install --no-install-recommends -y git python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libsasl2-dev python-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir pyOpenSSL uvicorn[standard]
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir transformers -U
COPY . .
CMD python3 -m uvicorn --host 0.0.0.0 main:app --reload