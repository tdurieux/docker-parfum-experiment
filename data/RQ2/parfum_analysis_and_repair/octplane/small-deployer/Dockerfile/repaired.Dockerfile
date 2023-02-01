FROM schickling/rust:latest

RUN apt-get update && apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

CMD /bin/bash
