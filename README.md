# Describing API Workflows with Arazzo (APIDays Paris 2024)

This sample solution showcases how to use the Arazzo Specification GPT, Spectral, VSCode, and Itarazzo to generate stellar API guides published to a SwaggerHub Portal instance. This is focused on showcasing emerging tooling to get started with the new [Arazzo Specification](https://spec.openapis.org/arazzo/latest.html) from the [OpenAPI Initiative](https://www.openapis.org/).

## Tools

- [Visual Studio Code](https://code.visualstudio.com/)
- [Arazzo Specification Custom GPT](https://chatgpt.com/g/g-673339c216648190a97a5fa3d8258769-arazzo-specification)
- [Spectral](https://github.com/stoplightio/spectral) -  flexible JSON/YAML linter for creating automated style guides, with baked in support for OpenAPI (v3.1, v3.0, and v2.0), Arazzo v1.0, as well as AsyncAPI v2.x.
- [Spectral VSCode Extension](https://marketplace.visualstudio.com/items?itemName=stoplight.spectral) - The Spectral VS Code Extension brings the power of Spectral to your VSCode IDE.
- [Prism](https://github.com/stoplightio/prism/) - an open-source HTTP mock and proxy server.
- [Itarazzo](https://github.com/leidenheit/itarazzo-client/tree/develop) - a testing tool for Arazzo Specification documents.
- [SwaggerHub Portal](https://swagger.io/tools/swaggerhub/features/swaggerhub-portal/) - an enterprise grade Developer Portal.

## Demonstration Steps

1. Take some existing APIs
2. Leverage 'Arazzo Specification' Custom GPT to kick start arazzo creation
3. Validate the produced Arazzo document using Spectral CLI
4. Fix feedback in VSCode Editor (this editing is enriched with Spectral extension)
5. Mock the two APIs using Prism
6. Test the workflow using the Itarazzo testing tool
7. Pass the tuned Arazzo document back into Arazzo Specification GPT to generate on-boarding guides
8. Update the markdown files in the code repository
9. Publish API and guides to a Developer portal (using GitHub action)
