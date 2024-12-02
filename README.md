# Describing API Workflows with Arazzo (APIDays Paris 2024)

This repo contains examples of using Arazzo in the wild. It focuses on working in a scenario where from existing APIs we want to craft and publish use case orientated workflows to a developer portal. These workflows clearly explain the capabilities and steps to integrate such capabilities (spanning multiple APIs) into a client application.

This sample repo showcases how to use the Arazzo Specification GPT, Spectral, VSCode, and Itarazzo to generate stellar API guides published to a SwaggerHub Portal instance. This is focused on showcasing emerging tooling to get started with the new [Arazzo Specification](https://spec.openapis.org/arazzo/latest.html) from the [OpenAPI Initiative](https://www.openapis.org/).

**You can choose your own adventure:**

- 💵 `Buy Now Pay Later` workflow - **this branch**
- 🐶 `Adopt a Pet` workflow - [pet adoptions](https://github.com/frankkilcommins/apidays-describing-api-workflows-with-arazzo/tree/pet-adoptions) branch

## Tools

- [Visual Studio Code](https://code.visualstudio.com/)
- [Arazzo Specification Custom GPT](https://chatgpt.com/g/g-673339c216648190a97a5fa3d8258769-arazzo-specification)
- [Spectral](https://github.com/stoplightio/spectral) -  flexible JSON/YAML linter for creating automated style guides, with baked in support for OpenAPI (v3.1, v3.0, and v2.0), Arazzo v1.0, as well as AsyncAPI v2.x.
- [Spectral VSCode Extension](https://marketplace.visualstudio.com/items?itemName=stoplight.spectral) - The Spectral VS Code Extension brings the power of Spectral to your VSCode IDE.
- [Prism](https://github.com/stoplightio/prism/) - an open-source HTTP mock and proxy server.
- [Itarazzo](https://github.com/leidenheit/itarazzo-client/tree/develop) - a testing tool for Arazzo Specification documents.
- [SwaggerHub Portal](https://swagger.io/tools/swaggerhub/features/swaggerhub-portal/) - an enterprise grade Developer Portal.

## Prerequisites

Set up the tools above and/or accounts where required.

## Demonstration Steps

1. Leverage **Arazzo Specification** Custom GPT to kick start Arazzo creation from existing APIs
2. Validate the produced Arazzo document using Spectral CLI
3. Fix feedback using VSCode Editor (with Arazzo enriched editing via the **Spectral extension**)
4. Test and validate the Workflow
   - Mock the APIs with **Prism**
   - Run/test the workflow with **Itarazzo**
   - View the generated reports
5. Pass the tuned Arazzo document back into Arazzo Specification GPT to generate on-boarding guides
6. Update the markdown files in the code repository
7. Publish API and guides to a Developer portal (using GitHub action)

## Our Workflow spans multiple APIs

The BNPL workflow we'll create will leverage operations exposed by the following APIs:

- **BNPL Eligibility API:** [view JSON](https://api.swaggerhub.com/apis/smartbear-api-hub/BNPL-Eligibility-And-Auth/1.0.0/swagger.json) or [view in SwaggerHub](https://app.swaggerhub.com/apis/smartbear-api-hub/BNPL-Eligibility-And-Auth/1.0.0)
- **BNPL Loans API:** [view JSON](https://api.swaggerhub.com/apis/smartbear-api-hub/BNPL-Loans/1.0.0/swagger.json) or [view in SwaggerHub](https://app.swaggerhub.com/apis/smartbear-api-hub/BNPL-Loans/1.0.0)

## What's currently in our Developer Portal

Let's take a quick look at the [SmartBearCoin](https://smartbearcoin.portal.swaggerhub.com/) developer portal to see existing products. This is where we want to end up publishing our new **Buy Now Pay Later** product.

It should look like:
![Developer Portal Before](./Developer-Portal-Before.png)

## Step 1. Generate a Buy Now Pay Later Workflow leveraging existing APIs

Rather than starting hand-crafting an Arazzo Document by hand, let's take advantage of the Arazzo Specification custom GPT that's available within OpenAI's ChatGPT store.

- Within ChatGPT add the `Arazzo Specification` custom GPT from the GPT store or access directly [here](https://chatgpt.com/g/g-673339c216648190a97a5fa3d8258769-arazzo-specification).
- Send a prompt similar to below containing instructions to create the BNPL Workflow in an Arazzo Document:

```text
There's two OpenAPI located at 
- https://api.swaggerhub.com/apis/smartbear-api-hub/BNPL-Eligibility-And-Auth/1.0.0/swagger.json
- https://api.swaggerhub.com/apis/smartbear-api-hub/BNPL-Loans/1.0.0/swagger.json

I'd like you to process those documents and generate a detailed Arazzo Document for a "BNPL Loan Application Workflow" based on the appropriate endpoints within the APIs above. Once you are ready, I will provide details on the steps to be included in the Arazzo workflow.

The workflow should  carry out the following steps: 
    1. Check selected Products are BNPL eligible
    2. Retrieve T&Cs and determine Customer eligibility
    3. Create customer record if needed
    4. Initiate BNPL Loan Transaction
    5. Authenticate Customer and obtain Authorization for Loan
    6. Calculate and retrieve Payment Plan to show within client app
    7. Update Order Status

Additional Notes: 
    • Use as much detail as possible. 
    • You MUST use the information contained within the OpenAPI files reference above when constructing requests, query params, path parameters, accessing response info etc. Do not make anything up. Use the schemas in the OpenAPI files to ensure the Arazzo document represents an executable workflow.
    • Ensure the Arazzo Document is valid according to the Arazzo Specification. 
    • Ensure step outputs are properly specified.
include one syntactical error that I can fix afterwards (e.g. omit the info.version).
```

> ℹ️ Note - I ask for at least one syntax issue which we can highlight with linting

## Step 2. Save the generated Arazzo and lint with Spectral

We can leverage Spectral to help validate the output from the Arazzo Specification GPT and weed out any syntax issues that may exist.

> Note: You should always validate from a human perspective that the generated Arazzo is also as expected and steps do what's intended.

1. Create a new file (e.g. `gpt.arazzo.yaml`) within `/gpt-generated`, and paste in the generated Arazzo document.
2. Create a `.spectral.yaml` file and extend the `Arazzo` core ruleset by adding the following

    ```yaml
    extends: ["spectral:arazzo"]
    ```

3. Lint the gpt generated file using Spectral CLI. Within your terminal run the following command:

    ```shell
    spectral lint ./gpt-generated/gpt.arazzo.yaml --ruleset ./gpt-generated/.spectral.yaml
    ```

Depending on the generated GPT you may see varying feedback from Spectral

![Spectral CLI Feedback](./spectral-cli-feedback.png)

## Step 3. Adjust and fix the Arazzo document in VSCode leveraging the **Spectral Extension**

We can use VSCode or any editor to adjust the Arazzo document and leverage the Spectral CLI commands again to verify our resolutions. Alternatively, to have a more enriched editing experience, we can enable the Spectral VSCode extension which also has built-in support for Arazzo. This allows us to get immediate feedback directly within the IDE.

Assuming the Spectral Extension is installed, create a `.spectral.yaml` file at the root of your project which extends the Arazzo core ruleset (this is the same content in the ruleset for the CLI and/or the VS Code extension).

```yaml
extends: ["spectral:arazzo"]
```

You now will get rich intellisense, documentation, syntax highlighting and more directly within files identified as Arazzo documents.

![Spectral VSCode Linting](./Spectral-VSCode-Linting.png)

## Step 4. Test and validate the Workflow

To test and validate the workflow we'll first mock the underlying APIs using **Prism** which can generate an API mock directly from an OpenAPI description, and then take advantage of a new open source tool called **Itarazzo** to run the workflow and get a generated report with feedback on the execution.

> ⚠️ Warning: Itarazzo will execute the workflow, so ensure you're using appropriate Servers and Security mechanisms
> note: you'll need to add the appropriate docker internal host server URLs to the OpenAPI descriptions, so that Itarazzo can make the appropriate requests (e.g. `http://host.docker.internal:8084`)

### Mock our Loan and Eligibility APIs using Prism and Docker

#### Mock Loans API

If you use `make` then run the pre-configured command:

```shell
make provider_mock_loans_prism
```

Alternatively, run the explicit docker / prism command:

```shell
docker run --add-host=host.docker.internal:host-gateway -d --init --rm --name prismL -v ${PWD}/specs:/specs -p 8084:4010 stoplight/prism:latest mock -h 0.0.0.0 "specs/bnpl-loan.openapi.yaml"
```

#### Verify the mock is available

Run the following curl command or pre-configured `make request-loan` command:

```shell
curl localhost:8084/loan-transactions/874150507946669 --header "Accept: application/json"
```

#### Mock Eligibility API

If you use `make` then run the pre-configured command:

```shell
make provider_mock_eligibility_prism
```

Alternatively, run the explicit docker / prism command:

```shell
docker run --add-host=host.docker.internal:host-gateway -d --init --rm --name prismE -v ${PWD}/specs:/specs -p 8085:4010 stoplight/prism:latest mock -h 0.0.0.0 "specs/bnpl-loan.openapi.yaml"
```

#### Verify the Eligibility API mock is available

Run the following curl command or pre-configured `make request-eligibility` command:

```shell
curl localhost:8085/terms-and-conditions --header "Accept: application/json"
```

### Execute the workflow using Itarazzo

For Itarazzo to run, it needs the Arazzo Document and a JSON file containing the necessary inputs (which naturally MUST be according to the schema defined in the Arazzo document for the workflow inputs).

Here's an example of the `/specs/formal-bnpl-arazzo-inputs.json` that we'll use for our workflow run.

```json
{
    "customer": {
      "uri": "https://api.example.com/customers/12345"
    },
    "products": [
      {
        "productCode": "PROD001",
        "purchaseAmount": {
          "currency": "USD",
          "amount": 299.99
        }
      },
      {
        "productCode": "PROD002",
        "purchaseAmount": {
          "currency": "USD",
          "amount": 159.49
        }
      }
    ]
  }
  
```

> ⚠️ Warning: Itarazzo will execute the workflow, so ensure you're using appropriate Servers and Security mechanisms
You can run the pre-configured `make` command to run Itarazzo:

```shell
make itarazzo_client
```

Alternatively, construct the appropriate docker run command like (note we also create a `reports` directory to store the generated report files):

```shell
mkdir -p reports
docker run -t --rm \
    --add-host=host.docker.internal:host-gateway \
    -e ARAZZO_FILE=/itarazzo/specs/formal-bnpl.arazzo.yaml \
    -e ARAZZO_INPUTS_FILE=/itarazzo/specs/formal-bnpl-arazzo-inputs.json \
    -v $$PWD/specs:/itarazzo/specs \
    -v $$PWD/reports:/itarazzo/target/reports \
    leidenheit/itarazzo-client
```

Head over the [Itarazzo GitHub](https://github.com/leidenheit/itarazzo-client/tree/develop) for more options.

🚀🚀 **We have a successfully executed workflow!!**

### View the generated report

Check out the `/reports/failsafe.html` for details on the workflow execution.

![Itarazzo Passing](./Itarazzo-passing.png)

### 🚨 What does failure look like?

To showcase what happens if the workflow fails, I've created a failing workflow. To execute the failing workflow run:

```shell
make itarazzo_client_error
```

Alternatively, run the docker run command:

```shell
mkdir -p reports
docker run -t --rm \
    --add-host=host.docker.internal:host-gateway \
    -e ARAZZO_FILE=/itarazzo/specs/error-bnpl.arazzo.yaml \
    -e ARAZZO_INPUTS_FILE=/itarazzo/specs/formal-bnpl-arazzo-inputs.json \
    -v $$PWD/specs:/itarazzo/specs \
    -v $$PWD/reports:/itarazzo/target/reports \
    leidenheit/itarazzo-client
```

### View the failure on generated report

Check out the `/reports/failsafe.html` for details on the workflow execution.

![Itarazzo failing](./Itarazzo-failing.png)


### What caused the error

We can drill into the Prism logs to get more info. Run:

```shell
make prism-loan-logs
```

Alternatively, run the docker command to get the last few logs:

```shell
docker logs --tail 10 -f prismL
```

```text
9:22:08 PM] ›     [NEGOTIATOR] ℹ  info      Request contains an accept header: */*
[9:22:08 PM] ›     [VALIDATOR] ⚠  warning   Request did not pass the validation rules
[9:22:08 PM] ›     [VALIDATOR] ✖  error     Request body must have required property 'status'
[9:22:08 PM] ›     [VALIDATOR] ✖  error     Request body must NOT have additional properties; found 'final-status'
[9:22:08 PM] ›     [NEGOTIATOR] ✔  success   Found response 400. I'll try with it.
[9:22:08 PM] ›     [NEGOTIATOR] ✔  success   The response 400 has an example. I'll keep going with this one
[9:22:08 PM] ›     [NEGOTIATOR] ✔  success   Responding with the requested status code 400
[9:22:08 PM] ›     [NEGOTIATOR] ℹ  info      > Responding with "400"
[9:22:08 PM] ›     [VALIDATOR] ✖  error     Violation: request.body Request body must have required property 'status'
[9:22:08 PM] ›     [VALIDATOR] ✖  error     Violation: request.body Request body must NOT have additional properties; found 'final-status'
```

We can see that the request made to the `PATCH /loan-transactions/{id}` was missing a required body property.

## Step 5. Generate Developer Docs from Arazzo

To improve the consuming developer experience and reduce the time and effort they need to expend integrating the Buy Now Pay Later workflow into their client applications, let's take advantage of Arazzo's determinism and use it to craft a stellar _Getting Started_ guide.

Rather than write this by hand, let's pass our refined Arazzo Document back into the **Arazzo Specification Custom GPT** and have it craft the docs for us.

### Sending the prompt to the GPT

The Arazzo Specification GPT has been trained on crafting Getting Started guides. Craft a prompt as follows for it to leverage training templates to produce the desired markdown output.

Here's a sample prompt to give you an idea:

```text
Use your training instruction template to generate a great documentation for our developer portal. 

Use the following additions for clarity:

The full content MUST be one piece of markdown that can be copied.
Include developer tips within each markdown section.

Here's the arazzo document to process:

<<PUT YOUR ARAZZO DOCUMENT HERE>>

```

> Have a little back an forth with the GPT if needed to get the output you're happy with

## Step 6. Update the markdown files in the code repository

Take the GPT markdown output and save it within `./products/Buy Now Pay Later/Getting-Started-with-BNPL.md`

> Tip: Manually adjust as required, spell check etc.
> NOTE: Ensure the `mermaid` block is closed (e.g. all the syntax should be within ```mermaid .....```)

## Step 7. Publish API and guides to a Developer portal (using GitHub action)

SwaggerHub Portal cannot yet (although coming soon!) render raw `mermaid` syntax, so let's convert the gpt generated `mermaid` syntax into a _PNG_. To do so run either of the following commands:

```shell
make mermaid-to-png
```

```shell
sh scripts/generate-images.sh
```

Now we're ready to commit and publish our new **Buy Now Pay Later** product to our portal. All the data and configurations are contained within `./products/Buy Now Pay Later/` and we've a GitHub action that takes advantage of the [SwaggerHub Portal APIs](https://www.youtube.com/watch?v=K4mGTkd8qcw) using a [Docs-As-Code](https://www.youtube.com/watch?v=7D5bbaj60Cc) convention-based process to structure the setup of the Portal products.

1. Commit the changes
2. Manually run the `Portal-Docs-Publish` Action on this repo using the `smartbearcoin` environment option

Now we've deployed our product to the portal:
![Developer Portal After](./Developer-Portal-After.png)
