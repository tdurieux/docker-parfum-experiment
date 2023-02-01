FROM platipy/platipy

RUN apt update; apt install --no-install-recommends -y plastimatch && rm -rf /var/lib/apt/lists/*;

COPY requirements-dirqa.txt requirements-dirqa.txt

RUN pip3 install --no-cache-dir -r requirements-dirqa.txt

COPY . .

ENV FLASK_APP service.py
