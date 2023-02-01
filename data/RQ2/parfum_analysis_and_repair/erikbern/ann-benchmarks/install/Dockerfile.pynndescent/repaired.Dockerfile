FROM ann-benchmarks

RUN pip3 install --no-cache-dir numpy==1.16.4 pynndescent >=0.5
RUN python3 -c 'import pynndescent'
