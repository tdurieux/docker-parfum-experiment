FROM openchemistry/stempy:latest

# Note these are the specfic versions needed to work with the jupyterlab
# deployment at NERSC, update with care!
RUN pip3 install --no-cache-dir -U ipykernel==6.4.2 ipympl==0.8.6 matplotlib==3.4.3

