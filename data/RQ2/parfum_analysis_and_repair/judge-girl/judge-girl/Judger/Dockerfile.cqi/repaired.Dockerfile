### Get Linux
FROM nvidia/cuda:10.0-base
RUN apt-get update && apt-get install --no-install-recommends -y gcc clinfo ocl-icd-libopencl1 opencl-headers ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y cgroup-bin cgroup-lite libcgroup1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libseccomp-dev libseccomp2 seccomp && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" >/etc/OpenCL/vendors/nvidia.icd

RUN apt-get update && apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
### Setup CQI-required dependencies
COPY Code-Quality-Inspection/requirements.txt /requirements.txt
COPY Code-Quality-Inspection/src/main/python /python
ENV PYTHONPATH=/python/code_style
ENV csa_python_main_path=/python/code_style/main.py
#### nltk (used in CSA) may require 'python3-dev' and 'musl-dev'
RUN apt-get update && apt-get install --no-install-recommends -y cppcheck python3 python3-pip python3-dev musl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 -m nltk.downloader words

## Prepare judger.jar
COPY target/judger-0.0.1-SNAPSHOT-jar-with-dependencies.jar /judger.jar

# Compile Profiler and copy it into judger home
COPY CC-Profiler-Sandbox/ /CC-Profiler-Sandbox/
WORKDIR /CC-Profiler-Sandbox
RUN gcc -std=c99 -o profiler main.c sandbox.c profiler.c logger.c killer.c rules/general.c rules/c_cpp.c rules/c_cpp_file_io.c -lpthread -lseccomp
RUN mkdir -p /judger-home/run && cp profiler /judger-home/run/profiler

WORKDIR /

CMD java -jar judger.jar




#python-source-root-path='/python/code_style/main/py' java -cp judger.jar tw.waterball.judgegirl.cqi.main