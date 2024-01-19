import { readFile, writeFile, rm, mkdir } from "fs/promises";
import { existsSync } from "fs";
import { join } from "path";
import ProgressBar from "progress";
import async from "async";
import Yargs from "yargs/yargs";
import { createHash } from "crypto";
import { Matcher, Violation, BINNACLE_RULES } from "@tdurieux/docker-parfum";
import * as dockerfile from "@tdurieux/dinghy";
import { File } from "@tdurieux/dinghy";

import * as utils from "../utils";
import config from "../../config";

export async function analyzeDockerfile(
  fileContent: string,
  filepath: string,
  outputPath: string
) {
  if (
    fileContent == "" ||
    fileContent.includes("FROM microsoft") ||
    fileContent.includes("powershell") ||
    fileContent.includes("FROM mcr.microsoft.com")
  )
    return;
  const output = {
    startTime: Date.now(),
    endTime: undefined,
    error: undefined,
    originalSmells: undefined,
    repairedSmells: undefined,
    repairedDockerfile: undefined,
  };
  try {
    const dockerParser = new dockerfile.DockerParser(
      new File(filepath, fileContent)
    );
    let repairedViolations: Violation[] = [];
    let ast = null;
    try {
      ast = dockerParser.parse();
    } catch (error) {
      if (error.ast) {
        ast = error.ast;
      } else {
        output.error = error;
      }
      return;
    }
    // if (dockerParser.errors.length > 0) {
    //   for (const error of dockerParser.errors) {
    //     console.log(error.message);
    //   }
    //   // console.log(fileContent);
    // }
    const matcher = new Matcher(ast);
    const violations: Violation[] = [];
    for (const rule of utils.SIZE_RULES) {
      try {
        matcher.match(rule).forEach((e) => violations.push(e));
      } catch (error) {}
    }
    output.originalSmells = violations.map(utils.smell2JSON);

    if (!existsSync(outputPath)) {
      await mkdir(outputPath, { recursive: true });
    }

    if (existsSync(join(outputPath, "repair.patch"))) {
      await rm(join(outputPath, "repair.patch"));
    }

    if (violations.length > 0) {
      for (const violation of violations) {
        try {
          await violation.repair();
        } catch (error) {
          console.error(error);
        }
      }

      if (!existsSync(outputPath)) {
        await mkdir(outputPath, { recursive: true });
      }

      const repaired_filecontent = ast.toString(true);
      output.repairedDockerfile = repaired_filecontent;

      const repairedDockerfilePath = join(outputPath, "repaired.Dockerfile");
      await writeFile(repairedDockerfilePath, repaired_filecontent, {
        encoding: "utf-8",
      });

      const repairedDockerParser = new dockerfile.dockerfileParser.DockerParser(
        new File(repairedDockerfilePath, repaired_filecontent)
      );

      let originalDockerfilePath = filepath;
      if (!filepath.includes("/")) {
        originalDockerfilePath = join(outputPath, "original.Dockerfile");
        await writeFile(originalDockerfilePath, fileContent, {
          encoding: "utf-8",
        });
      }

      // execute git diff between original and repaired dockerfile
      const diff = await utils.executeCommand(
        `git --no-pager diff --no-index --color=never "${originalDockerfilePath}" "${repairedDockerfilePath}"`
      );
      await writeFile(join(outputPath, "repair.patch"), diff);

      let repairedAst = null;
      try {
        repairedAst = repairedDockerParser.parse();
      } catch (error) {
        if (error.ast) {
          repairedAst = error.ast;
        }
      }
      if (repairedAst !== null) {
        const repairedMatcher = new Matcher(repairedAst);
        for (const rule of utils.SIZE_RULES) {
          try {
            repairedMatcher
              .match(rule)
              .forEach((e) => repairedViolations.push(e));
          } catch (error) {}
        }
        output.repairedSmells = repairedViolations.map(utils.smell2JSON);
      }
    }
  } catch (error) {
    console.log(error);
    output.error = error.message;
  } finally {
    if (!existsSync(outputPath)) {
      await mkdir(outputPath, { recursive: true });
    }
    output.endTime = Date.now();
    await writeFile(
      join(outputPath, "results.json"),
      JSON.stringify(output, null, 2),
      { encoding: "utf-8" }
    );
  }
  return output.repairedSmells;
}

if (require.main === module) {
  (async () => {
    const argv = await Yargs(process.argv.slice(2))
      .option("dockerfilePath", {
        type: "string",
        default: config.defaultDockerfileOutputPath,
      })
      .option("output", {
        type: "string",
        default: config.defaultRepairedDockerfileOutputPath,
        alias: "o",
      })
      .option("process", {
        type: "number",
        default: 8,
        alias: "p",
        description: "Number of parallel repair",
      })
      .option("skip-existing", {
        type: "boolean",
        default: true,
        alias: "s",
        description: "Skip repairs that have been done",
      })
      .parse();
    const repoFileLists = utils.walkSync(argv.dockerfilePath);
    // repoFileLists.sort(() => (Math.random() > 0.5 ? 1 : -1));

    const bar = new ProgressBar(
      "[:bar] :current/:total :rate/bps :percent :etas :step",
      {
        complete: "=",
        incomplete: " ",
        width: 30,
        total: repoFileLists.length,
      }
    );

    const uniqueFile = new Set<string>();

    async.forEachOfLimit(
      repoFileLists,
      argv.process,
      async (path, _, callback) => {
        const filename = path.replace(argv.dockerfilePath + "/", "");
        bar.tick({ step: filename });
        
        const content = await readFile(path, "utf-8");
        const hash = createHash("sha1").update(content).digest("base64");
        if (uniqueFile.has(hash)) return callback();
        uniqueFile.add(hash);

        const outputPath = join(argv.output, filename);
        if (argv.skipExisting && existsSync(join(outputPath, "results.json")))
          return callback();

        try {
          await analyzeDockerfile(content, path, outputPath);
        } catch (e) {
          console.error(e);
        } finally {
          callback();
        }
      },
      () => {
        console.log(`[Done] Unique Dockerfiles: ${uniqueFile.size}`);
      }
    );
  })();
}
