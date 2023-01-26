import { readFile, readdir, rm } from "fs/promises";
import { join } from "path";
import { RepositoryAnalysisResult } from "../repair_repository_dockerfile";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { File, ShellParser, nodeType } from "@tdurieux/dinghy";

const errorsRegExps: { [key: string]: RegExp | RegExp[] } = {
  "invalid based name": /base name (?<NAME>.*) should not be blank/,
  "invalid platform":
    /failed to parse platform : "(?<PLATFROM>.*)" is an invalid component of ".*": platform specifier component must match "\^\[A-Za-z0-9_-\]\+\$": invalid argument/,
  "invalid stage name":
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: failed to parse stage name "(?<NAME>.*)"(?<ERROR>.*)/,
  "invalid based image": [
    /manifest for (?<IMAGE>.*) not found: (?<ERROR>.*)/,
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: no match for platform in manifest (?<IMAGE>.*): (?<ERROR>.*)/,
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: (?<IMAGE>.*): (?<ERROR>.*)/,
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: unexpected status code [(?<CODE>.*)]/,
    /invalid reference format: repository name must be lowercase/,
  ],
  "command error": [
    /The command '(?<CMD>.*)' returned a non-zero code: (?<CODE>.*)/,
    /executor failed running \[(?<CMD>.*)\]: exit code: (?<CODE>.*)/,
  ],
  "dockerfile parsing error": [
    /Error response from daemon: dockerfile parse error (?<ERROR>.*)/,
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: Syntax error - (?<ERROR>.*)/,
    /invalid character '(?<VALUE>.*)' looking for beginning of value/,
    /failed to process "(?<VALUE>.*)": (?<ERROR>.*)/,
    /Error response from daemon: failed to parse Dockerfile: (?<ERROR>.*)/,
  ],
  "pull denied": [
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: pull access denied, repository does not exist or may require authorization:(?<ERROR>.*)/,
    /pull access denied for (?<IMAGE>.*)/,
  ],
  "request failed": [
    /Head "(?<URL>.*)": (?<ERROR>.*)/,
    /Get "(?<URL>.*)": dial tcp: lookup (?<HOST>.*): (?<ERROR>.*)/,
    /(?<INSTRUCTION>.*) failed: failed to GET (?<URL>.*) with status (?<ERROR>.*)/,
    /(?<INSTRUCTION>.*) failed: Get "(?<URL>.*)": (?<ERROR>.*)/,
    /failed to solve with frontend dockerfile.v0: failed to create LLB definition: failed to do request: (?<URL>.*): (?<ERROR>.*)/,
    /failed to load cache key: Get "(?<URL>.*)": (?<ERROR>.*)/,
    /Get "(?<URL>.*)": net\/http: (?<ERROR>.*)/,
  ],
  "failed copy/add": [
    /(?<INSTRUCTION>.*) failed: no source files were specified/,
    /(?<INSTRUCTION>.*) failed: stat (?<FILE>.*): (?<ERROR>.*)/,
    /(?<INSTRUCTION>.*) failed: file not found in build context or excluded by \.dockerignore: (?<FILE>.*): (?<ERROR>.*)/,
    /failed to compute cache key: "(?<FILE>.*)" (?<ERROR>.*)/,
    /unable to prepare context: unable to evaluate symlinks in Dockerfile path: (?<FILE>.*): (?<ERROR>.*)/,
    /When using (?<INSTRUCTION>.*) with more than one source file, the destination must be a directory and end with a \//,
  ],
  "docker error": [
    /Error response from daemon: Bad response from Docker engine/,
    /Error response from daemon: dial unix docker.raw.sock: connect: no such file or directory/,
    /toomanyrequests: You have reached your pull rate limit. You may increase the limit by authenticating and upgrading: (?<URL>.*)/,
  ],
  "dockerfile not found": [
    /failed to solve with frontend dockerfile.v0: failed to read dockerfile: open (?<FILE>.*): (?<ERROR>.*)/,
  ],
  "tar error": [
    /time="(?<date>.*)" level=error msg="Can't close tar writer: (?<ERROR>.*)"/,
    /time="(?<date>.*)" level=error msg="Can't add file (?<FILE>.*) to tar: (?<ERROR>.*)"/,
  ],
  "BuildKit missing": [
    /the (?<OPTION>.*) option requires BuildKit. Refer to (?<URL>.*) to learn how to build images with BuildKit enabled/,
  ],
};

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      alias: "p",
      description: "The path to the repository analysis results",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .option("repaired", {
      type: "boolean",
      alias: "r",
      description: "Whether to show errors in the repaired builds",
    })
    .parse();

  const owners = await readdir(argv.resultPath);
  const errors: { [key: string]: string[] } = {};
  const issueWithCmds: { [key: string]: string[] } = {};
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      const path = join(argv.resultPath, owner, repoFile);
      const results: RepositoryAnalysisResult = JSON.parse(
        await readFile(path, "utf-8")
      );
      let buildResult = results.originalBuild;
      if (argv.repaired) {
        if (results.originalBuild.error || !results.repairedBuild) continue;
        if (!results.repairedBuild.error) continue;
        buildResult = results.repairedBuild;
      } else {
        if (!results.originalBuild.error) continue;
      }

      if (
        buildResult.error &&
        buildResult.error.code === "ERR_CHILD_PROCESS_STDIO_MAXBUFFER"
      ) {
        errors["max buffer"] = errors["max buffer"] || [];
        errors["max buffer"].push(results.repository);
        continue;
      }

      let lastLine = buildResult.stderr.trim().split("\n").at(-1);
      let errorMatched = false;
      errorsRegExpsLoop: for (let [error, regex] of Object.entries(
        errorsRegExps
      )) {
        if (!Array.isArray(regex)) {
          regex = [regex];
        }
        for (const r of regex) {
          const match = lastLine.match(r);
          if (match) {
            errors[error] = errors[error] || [];
            errors[error].push(results.repository);
            errorMatched = true;
            if (match.groups?.CMD) {
              const p = new nodeType.Position(0, 0);
              p.file = new File("Dockerfile", match.groups.CMD);
              const parser = new ShellParser(match.groups.CMD, p);
              const ast = await parser.parse();
              if (parser.errors.length > 0) {
                console.log(parser.errors);
              }
              // console.log(ast.children[0].toString())
              // (await parseShell(match.groups.CMD))
              //   .getElements(BashCommandCommand)
              //   .forEach((cmd) => {
              //     console.log(cmd.toString());
              //   });
            }
            break errorsRegExpsLoop;
          }
        }
      }

      if (!errorMatched) {
        errors[lastLine] = errors[lastLine] || [];
        errors[lastLine].push(results.repository);

        errors["unknown"] = errors["unknown"] || [];
        errors["unknown"].push(results.repository);

        // console.log(buildResult.error);
      }

      if (
        lastLine.startsWith("toomanyrequests") ||
        lastLine.startsWith("Cannot connect to the Docker daemon") ||
        (results.originalBuild.stderr == "" &&
          results.originalBuild.stdout == "")
      ) {
        await rm(path);
      }
    }
  }
  for (const err of Object.keys(errors).sort(
    (a, b) => errors[a].length - errors[b].length
  )) {
    console.log(`${err},${errors[err].length}`);
  }
})();
