FROM rocm/dev-ubuntu-20.04

RUN apt-get update && apt-get -y --no-install-recommends install rocblas rocfft rocrand rocalution rocsparse miopen-hip && rm -rf /var/lib/apt/lists/*;
