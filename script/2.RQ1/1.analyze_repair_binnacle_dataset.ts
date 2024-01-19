import lzma from "lzma-native";
import tar from "tar-stream";
import fs from "fs";
import { join, resolve } from "path";
import ProgressBar from "progress";
import config from "../../config";
import { readFile } from "fs/promises";
import { analyzeDockerfile } from "./2.analyze_repair_new_dataset";

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
        fileName
      );

      if (fs.existsSync(join(outputPath, "results.json"))) {
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
        try {
          await analyzeDockerfile(fileContent, fileName, outputPath);
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
    fs.createReadStream(join(config.datasetFolder, "binnacle", "github.tar.xz"))
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
