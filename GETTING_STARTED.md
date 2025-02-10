# API Workflows with Arazzo & Specmatic

This repo contains examples of using Arazzo in the wild. It focuses on working in a scenario where from existing APIs we want to craft and publish use case orientated workflows to a developer portal. These workflows clearly explain the capabilities and steps to integrate such capabilities (spanning multiple APIs) into a client application.

This sample repo showcases how to use the Arazzo Specification with Specmatic to test API Workflow tests. This is focused on showcasing emerging tooling to get started with the new [Arazzo Specification](https://spec.openapis.org/arazzo/latest.html) from the [OpenAPI Initiative](https://www.openapis.org/).

## Getting Started
### This Repo
```shell
git clone https://github.com/znsio/apidays-describing-api-workflows-with-arazzo.git
```

### Dependency
```shell
git clone git@github.com/znsio/openapi-workflow-parser.git
git checkout dev
mvn clean install
cd ..

git clone git@github.com:znsio/specmatic.git
git checkout ar-spec
./gradlew clean publishToMavenLocal
cd ..

git clone git@github.com:znsio/specmatic-arazzo.git
./gradlew clean publishToMavenLocal -PenableShadowJar=true
cd ..
```

#### Starting the stub server
```shell
mkdir -p .specmatic
curl -L -o .specmatic/specmatic.jar https://github.com/znsio/specmatic/releases/latest/download/specmatic.jar
java -jar .specmatic/specmatic.jar stub --strict
```

#### Running the Workflow tests
```shell
java -jar ~/.m2/repository/io/specmatic/specmatic-arazzo/0.0.1/specmatic-arazzo-0.0.1-all.jar test
```

#### Report
```shell
open build/reports/specmatic/html/index.html
```