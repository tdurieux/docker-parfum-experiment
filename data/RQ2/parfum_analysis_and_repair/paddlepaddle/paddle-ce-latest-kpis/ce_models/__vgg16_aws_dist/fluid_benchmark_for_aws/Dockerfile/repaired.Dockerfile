FROM paddlepaddlece/paddle:latest

ENV HOME /root
COPY ./ /root/
WORKDIR /root
RUN apt install --no-install-recommends -y python-opencv && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["python", "fluid_benchmark.py"]