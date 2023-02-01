FROM julia:0.7

COPY . /app

RUN apt-get update && apt-get install --no-install-recommends -y gcc apt-utils unzip make libhttp-parser-dev && rm -rf /var/lib/apt/lists/*;
RUN julia /app/deps.jl

CMD julia /app/app.jl
EXPOSE 3000
