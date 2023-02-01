FROM python:3.8.12
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir torch==1.9.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
ENTRYPOINT [ "python" ]
