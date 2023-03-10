FROM vivado2019:2019.2

# more packages: qemu-system-mips expect python3-serial iverilog yosys
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y curl make verilator python3-lxml python3-chardet && \
    curl -f -L -o Codescape.GNU.Tools.Package.2016.05-06.for.MIPS.MTI.Bare.Metal.CentOS-5.x86_64.tar.gz 'https://cloud.tsinghua.edu.cn/f/16dde018b00749a4a4de/?dl=1' && \
    sudo tar -C /opt -xf Codescape.GNU.Tools.Package.2016.05-06.for.MIPS.MTI.Bare.Metal.CentOS-5.x86_64.tar.gz && \
    rm Codescape.GNU.Tools.Package.2016.05-06.for.MIPS.MTI.Bare.Metal.CentOS-5.x86_64.tar.gz && rm -rf /var/lib/apt/lists/*;

#ENV PATH="/opt/mips-mti-elf/2016.05-06/bin:${PATH}"
RUN echo 'export PATH=/opt/mips-mti-elf/2016.05-06/bin:${PATH}' >>~/.bashrc
