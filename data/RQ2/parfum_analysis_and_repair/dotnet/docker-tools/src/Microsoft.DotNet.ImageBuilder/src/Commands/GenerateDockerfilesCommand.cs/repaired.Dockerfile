// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Cottle;
using Microsoft.DotNet.ImageBuilder.Models.Manifest;
using Microsoft.DotNet.ImageBuilder.ViewModel;

namespace Microsoft.DotNet.ImageBuilder.Commands
{
    [Export(typeof(ICommand))]
    public class GenerateDockerfilesCommand : GenerateArtifactsCommand<GenerateDockerfilesOptions, GenerateDockerfilesOptionsBuilder>
    {

        [ImportingConstructor]
        public GenerateDockerfilesCommand(IEnvironmentService environmentService) : base(environmentService)
        {
        }

        protected override string Description => "Generates the Dockerfiles from Cottle based templates (http://r3c.github.io/cottle/)";

        public override async Task ExecuteAsync()
        {
            Logger.WriteHeading("GENERATING DOCKERFILES");

            await GenerateArtifactsAsync(
                Manifest.GetFilteredPlatforms(),
                (platform) => platform.DockerfileTemplate,
                (platform) => platform.DockerfilePath,
                (platform, templatePath, indent) => GetTemplateState(platform, templatePath, indent),
                nameof(Platform.DockerfileTemplate),
                "Dockerfile");

            ValidateArtifacts();
        }

        public (IReadOnlyDictionary<Value, Value> Symbols, string Indent) GetTemplateState(PlatformInfo platform, string templatePath, string indent)
        {
            string versionedArch = platform.Model.Architecture.GetDisplayName(platform.Model.Variant);
            ImageInfo image = Manifest.GetImageByPlatform(platform);

            Dictionary<Value, Value> symbols = GetSymbols(
                templatePath,
                platform,
                (platform, templatePath, currentIndent) => GetTemplateState(platform, templatePath, currentIndent + indent),
                indent);
            symbols["ARCH_SHORT"] = platform.Model.Architecture.GetShortName();
            symbols["ARCH_NUPKG"] = platform.Model.Architecture.GetNupkgName();
            symbols["ARCH_VERSIONED"] = versionedArch;
            symbols["ARCH_TAG_SUFFIX"] = $"-{versionedArch}";
            symbols["PRODUCT_VERSION"] = image.ProductVersion;
            symbols["OS_VERSION"] = platform.Model.OsVersion;
            symbols["OS_VERSION_BASE"] = platform.BaseOsVersion;
            symbols["OS_VERSION_NUMBER"] = GetOsVersionNumber(platform);
            symbols["OS_ARCH_HYPHENATED"] = GetOsArchHyphenatedName(platform);

            return (symbols, indent);
        }

        private static string GetOsVersionNumber(PlatformInfo platform)
        {
            const string PrefixGroup = "Prefix";
            const string VersionGroup = "Version";
            const string LtscPrefix = "ltsc";
            Match match = Regex.Match(platform.Model.OsVersion, @$"(-(?<{PrefixGroup}>[a-zA-Z_]*))?(?<{VersionGroup}>\d+.\d+)");

            string versionNumber = string.Empty;
            if (match.Groups[PrefixGroup].Success && match.Groups[PrefixGroup].Value == LtscPrefix)
            {
                versionNumber = LtscPrefix;
            }

            versionNumber += match.Groups[VersionGroup].Value;
            return versionNumber;
        }

        private static string GetOsArchHyphenatedName(PlatformInfo platform)
        {
            string osName;
            if (platform.BaseOsVersion.Contains("nanoserver"))
            {
                string version = platform.BaseOsVersion.Split('-')[1];
                osName = $"NanoServer-{version}";
            }
            else if (platform.BaseOsVersion.Contains("windowsservercore"))
            {
                string version = platform.BaseOsVersion.Split('-')[1];
                osName = $"WindowsServerCore-{version}";
            }
            else
            {
                osName = platform.GetOSDisplayName().Replace(' ', '-');
            }

            string archName = platform.Model.Architecture != Architecture.AMD64 ? $"-{platform.Model.Architecture.GetDisplayName()}" : string.Empty;

            return osName + archName;
        }
    }
}