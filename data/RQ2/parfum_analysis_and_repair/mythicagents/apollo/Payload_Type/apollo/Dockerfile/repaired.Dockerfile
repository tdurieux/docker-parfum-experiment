from itsafeaturemythic/csharp_payload:0.1.1
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3.8 -m pip install donut-shellcode
