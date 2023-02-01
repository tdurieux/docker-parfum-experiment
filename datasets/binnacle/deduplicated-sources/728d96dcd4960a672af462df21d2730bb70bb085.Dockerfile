FROM mono:5
COPY . /tmp/
WORKDIR /tmp
RUN msbuild /t:restore /p:TargetFrameworks=net461 && \
  msbuild /t:build /p:TargetFrameworks=net461
CMD mono ~/.nuget/packages/xunit.runner.console/2.4.0/tools/net461/xunit.console.exe OhmGraphite.Test/bin/Debug/net461/OhmGraphite.Test.dll
