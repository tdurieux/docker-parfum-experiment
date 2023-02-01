import { ICaptainDefinition } from '../../../../models/ICaptainDefinition'
import UploaderPlainTextBase from './UploaderPlainTextBase'

export default class UploaderPlainTextDockerfile extends UploaderPlainTextBase {
    protected getPlaceHolderValue() {
        return `# Derived from official mysql image (our base image)
FROM mysql:5.7
# Add a database
ENV MYSQL_DATABASE company`
    }

    protected convertDataToCaptainDefinition(userEnteredValue: string) {
        const capDefinition: ICaptainDefinition = {
            schemaVersion: 2,
            dockerfileLines: userEnteredValue.trim().split('\n'),
        }

        return JSON.stringify(capDefinition)
    }
}
