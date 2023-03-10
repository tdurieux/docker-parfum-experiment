FROM cirrusci/windowsservercore:2019

#RUN choco upgrade all -y
#RUN choco upgrade -y visualstudio2017community visualstudio2017-workload-vctools
RUN choco install -y cmake vcredist2017 windows-sdk-10.1 --ignoredetectedreboot --ignorepackagecodes --no-progress
#RUN choco install -y visualstudio2019community --ignoredetectedreboot --ignorepackagecodes --package-parameters "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.140"
RUN choco install -y visualstudio2019buildtools --no-progress --ignorepackagecodes --ignoredetectedreboot --timeout 900 -v --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.18362 --add Microsoft.Component.VC.Runtime.UCRTSDK --no-includeRecommended" 
#RUN choco install visualstudio2019-workload-nativedesktop visualstudio2019-workload-vctools --ignoredetectedreboot --ignorepackagecodes -y --package-parameters "--no-includeRecommended"
#RUN choco install -y aria2 --version 1.32.0.1 --ignoredetectedreboot -d

WORKDIR C:/Program\ Files/CMake/bin
RUN .\cmake -E make_directory C:/lib
RUN .\cmake -E make_directory C:/include
RUN .\cmake -E make_directory C:/vcpkg