FROM friwidev/jcefdocker:windows-latest

WORKDIR C:/

#Copy cmake patching script
COPY scripts/patch_cmake.py .
COPY patch/CMakeLists.txt.patch .

#Copy and launch run script
COPY scripts/run_windows.bat .
ENTRYPOINT ["run_windows.bat"]