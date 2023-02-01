FROM julia:latest

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config git && rm -rf /var/lib/apt/lists/*;
