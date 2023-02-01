FROM nucypher/rust-python:3.8.12

WORKDIR /code
COPY . /code

RUN pip3 install --no-cache-dir .[ursula]
RUN export PATH="$HOME/.local/bin:$PATH"

CMD ["/bin/bash"]
