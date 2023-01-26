import { existsSync } from "fs";
import { mkdir, readFile, writeFile } from "fs/promises";
import { dirname, join } from "path";

import async from "async";
import ProgressBar from "progress";
import Yargs from "yargs/yargs";

import { Violation } from "@tdurieux/docker-parfum";

import { analyze } from "./repair_repository_dockerfile";
import config from "../../config";
import { iterateVulnerabilityAnalysis } from "../utils";

if (require.main === module) {
  (async () => {
    const argv = await Yargs(process.argv)
      .option("parallel", {
        type: "number",
        default: 10,
        alias: "p",
      })
      .option("repositoryListPath", {
        alias: "l",
        type: "string",
      })
      .option("skipExisting", {
        type: "boolean",
        default: true,
      })
      .option("outputPath", {
        type: "string",
        default: config.defaultBuildDockerfileOutputPath,
      })
      .option("resultPath", {
        type: "string",
        default: config.defaultRepairedDockerfileOutputPath,
      })
      .option("workdir", {
        type: "string",
        default: "/tmp/dinghy-analysis",
      })
      .parse();

    const toAnalyze: {
      repositoryUrl: string;
      dockerfilePath: string;
    }[] = [];
    if (argv.repositoryListPath && existsSync(argv.repositoryListPath)) {
      (await readFile(argv.repositoryListPath, "utf-8"))
        .split("\n")
        .forEach((line) => {
          if (line.trim() === "") return;
          const [repositoryUrl, dockerfilePath] = line.split(",");
          const [owner, repo] = repositoryUrl.split("/").slice(-2);
          if (
            argv.skipExisting &&
            existsSync(join(argv.outputPath, owner, repo + ".json"))
          ) {
            return;
          }

          toAnalyze.push({ repositoryUrl, dockerfilePath });
        });
    } else {
      await iterateVulnerabilityAnalysis(
        async (analysis) => {
          if (!analysis.repository) return;

          const originalAnalisis: Violation[] = JSON.parse(
            await readFile(
              analysis.path.replace(
                "repaired_violations.json",
                "violations.json"
              ),
              "utf-8"
            )
          );

          const dockerPath = analysis.path
            .replace(
              `${argv.resultPath}/${analysis.owner}/${analysis.repo}/`,
              ""
            )
            .replace("/repaired_violations.json", "");
          if (originalAnalisis.length == 0) return;
          if (dockerPath !== "Dockerfile") return;

          if (
            argv.skipExisting &&
            existsSync(
              join(argv.outputPath, analysis.owner, analysis.repo + ".json")
            )
          ) {
            return;
          }

          toAnalyze.push({
            repositoryUrl: `https://github.com/${analysis.owner}/${analysis.repo}`,
            dockerfilePath: dockerPath,
          });
        },
        argv.resultPath,
        (path) => path.endsWith("repaired_violations.json")
      );
    }
    toAnalyze.sort((a, b) => (Math.random() > 0.5 ? 1 : -1));
    console.log(`Total: ${toAnalyze.length}`);

    const bar = new ProgressBar(
      "[:bar] :current/:total :rate/bps :percent :etas :step",
      {
        complete: "=",
        incomplete: " ",
        width: 30,
        total: toAnalyze.length,
      }
    );
    async.forEachOfLimit(
      toAnalyze,
      argv.parallel,
      async (repo, _, callback) => {
        const [owner, repoName] = repo.repositoryUrl.split("/").slice(-2);
        try {
          const outputR = await analyze({
            repository: repo.repositoryUrl,
            dockerfilePath: repo.dockerfilePath,
            workdirectory: join(argv.workdir, owner),
          });

          const outputFile = join(argv.outputPath, owner, `${repoName}.json`);

          if (!existsSync(dirname(outputFile))) {
            await mkdir(dirname(outputFile), { recursive: true });
          }
          await writeFile(outputFile, JSON.stringify(outputR), {
            encoding: "utf-8",
          });
        } catch (e) {
          console.error(e);
        } finally {
          bar.tick({ step: `${owner}/${repoName}\n` });
          callback();
        }
      }
    );
  })();
}
