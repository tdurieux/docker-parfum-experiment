RUN apt-get update && apt-get install -y --no-install-recommends \
    rocfft rocblas \
    rocm-libs miopen-hip cxlactivitylogger && rm -rf /var/lib/apt/lists/*;

