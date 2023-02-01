FROM mtiller/book-py

RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;

