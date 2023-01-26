import lzma from "lzma-native";
import tar from "tar-stream";
import fs from "fs";
import { basename, join } from "path";
import { nodeType, parseDocker } from "@tdurieux/dinghy";
import ProgressBar from "progress";
import { writeFile } from "fs/promises";
import config from "../../../config";

(async () => {
  return new Promise<void>((resolve) => {
    const extract = tar.extract();

    const bar = new ProgressBar(
      "[:bar] :current :rate/bps :percent :etas :step",
      {
        complete: "=",
        incomplete: " ",
        width: 30,
        total: 198000,
      }
    );

    const distribution = {};
    extract.on("entry", function (header, stream, next) {
      let fileContent = "";
      stream.on("end", async function () {
        try {
          const ast = await parseDocker(fileContent);
          ast.getElements(nodeType.BashCommandCommand).forEach((command) => {
            const cmd = command.toString(true);
            distribution[cmd] = distribution[cmd] ? distribution[cmd] + 1 : 1;
          });
        } catch (error) {
          console.log(error);
        } finally {
          bar.tick({ step: basename(header.name) });
          next();
        }
      });
      stream.on("data", (d: Buffer) => {
        fileContent += d.toString("utf-8");
      });
    });

    extract.on("finish", function () {
      // all entries done - lets finalize it
      console.log(JSON.stringify(distribution, null, 2));
    });

    setInterval(async () => {
      await writeFile(
        "distribution_command.json",
        JSON.stringify(distribution, null, 2)
      );
    }, 10000);
    fs.createReadStream(
      join(config.dataFolder, "reproduction/github.tar.xz")
    )
      .pipe(lzma.createDecompressor())
      .pipe(extract)
      .on("finish", () => resolve());
  });
})();
