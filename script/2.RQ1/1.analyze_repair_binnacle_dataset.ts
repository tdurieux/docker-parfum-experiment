import lzma from "lzma-native";
import tar from "tar-stream";
import fs from "fs";
import { join, resolve } from "path";
import * as dockerfile from "@tdurieux/dinghy";
import ProgressBar from "progress";
import { File } from "@tdurieux/dinghy";
import { BINNACLE_RULES, Matcher, Violation } from "@tdurieux/docker-parfum";
import config from "../../config";
import { readFile, writeFile } from "fs/promises";
import { smell2JSON } from "../utils";

async function analyze(fileName: string, fileContent: string) {
  const output = {
    startTime: Date.now(),
    endTime: undefined,
    error: undefined,
    originalSmells: undefined,
    repairedSmells: undefined,
    repairedDockerfile: undefined,
  };
  const outputPath = join(
    config.defaultBinnacleAnalysisAndRepairPath,
    fileName + ".json"
  );
  const dockerParser = new dockerfile.DockerParser(
    new File(fileName, fileContent)
  );
  try {
    const ast = await dockerParser.parse();
    if (dockerParser.errors.length > 0) {
      for (const error of dockerParser.errors) {
        console.log("[AST ERROR]", error.message);
      }
      // console.log(fileContent);
    }
    const matcher = new Matcher(ast);
    const violations: Violation[] = [];
    for (const rule of BINNACLE_RULES) {
      matcher.match(rule).forEach((e) => violations.push(e));
    }
    output.originalSmells = violations.map(smell2JSON);
    if (violations.length === 0) {
      return;
    }
    try {
      for (const violation of violations) {
        try {
          await violation.repair();
        } catch (error) {
          console.error(error);
        }
      }
      const repairedAst = await new dockerfile.DockerParser(
        new File(fileName, ast.toString(true))
      ).parse();
      output.repairedDockerfile = repairedAst.position.file.content;
      const repairedMatcher = new Matcher(repairedAst);
      const repairedViolations: Violation[] = [];
      for (const rule of BINNACLE_RULES) {
        repairedMatcher.match(rule).forEach((e) => repairedViolations.push(e));
      }
      output.repairedSmells = repairedViolations.map(smell2JSON);
    } catch (error) {
      console.error("\n" + fileName, error);
    }
  } catch (error) {
    console.error(`\nERROR at ${fileName}`);
    console.error(error);
    output.error = error.message;
  } finally {
    output.endTime = Date.now();
    await writeFile(outputPath, JSON.stringify(output, null, 2), "utf-8");
  }
}
export async function analyzeZip(toAnalyze: (filename: string) => boolean) {
  return new Promise<void>(() => {
    const bar = new ProgressBar(
      "[:bar] :current/:total :rate/bps :percent :etas :step",
      {
        complete: "=",
        incomplete: " ",
        width: 30,
        total: 178506,
      }
    );
    const extract = tar.extract();

    extract.on("entry", function (header, stream, next) {
      const fileName = header.name
        .replace(".Dockerfile", "")
        .replace("./deduplicated-sources-gold/", "")
        .replace("deduplicated-sources/", "");

      bar.tick({ step: fileName });
      if (!toAnalyze(fileName)) {
        stream.resume();
        return next();
      }
      const outputPath = join(
        config.defaultBinnacleAnalysisAndRepairPath,
        fileName + ".json"
      );

      if (fs.existsSync(outputPath)) {
        stream.resume();
        return next();
      }
      let fileContent = "";
      stream.on("data", (d: Buffer) => {
        fileContent += d.toString("utf-8");
      });

      stream.on("error", (error) => {
        console.error(error);
        stream.resume();
        next();
      });

      stream.on("end", async () => {
        // if (
        //   fileContent == "" ||
        //   fileContent.includes("FROM microsoft") ||
        //   fileContent.includes("powershell") ||
        //   fileContent.includes("FROM mcr.microsoft.com")
        // ) {
        //   return next();
        // }

        try {
          await analyze(fileName, fileContent);
        } catch (error) {
          console.error(error);
        } finally {
          next();
        }
      });
    });

    extract.on("finish", function () {
      resolve();
    });
    fs.createReadStream(
      join(config.dataFolder, "reproduction", "github.tar.xz")
    )
      .pipe(lzma.createDecompressor())
      .pipe(extract);
  });
}
(async () => {
  const analyzeAll = true;
  if (!analyzeAll) {
    const files = new Set();
    (await readFile("./diffR.csv", "utf-8"))
      .split("\n")
      .forEach((line) => files.add(line.split(",")[0]));
    await analyzeZip((f) => files.has(f));
  } else {
    await analyzeZip((f) => true);
  }
})();
