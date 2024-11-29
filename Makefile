OAS_LOAN_FILE?=specs/bnpl-loan.openapi.yaml
OAS_ELIGIBILITY_FILE?=specs/bnpl-eligibility.openapi.yaml


provider_mock_loans_prism: ## Runs a mock server with Prism, generated from the OpenAPI specification
	docker run --add-host=host.docker.internal:host-gateway -d --init --rm --name prismL -v ${PWD}/specs:/specs -p 8084:4010 stoplight/prism:latest mock -h 0.0.0.0 "/${OAS_LOAN_FILE}"

request-loan:
	curl localhost:8084/loan-transactions/874150507946669 --header "Accept: application/json"

provider_mock_eligibility_prism: ## Runs a mock server with Prism, generated from the OpenAPI specification
	docker run --add-host=host.docker.internal:host-gateway -d --init --rm --name prismE -v ${PWD}/specs:/specs -p 8085:4010 stoplight/prism:latest mock -h 0.0.0.0 "/${OAS_ELIGIBILITY_FILE}"

request-eligibility:
	curl localhost:8085/terms-and-conditions --header "Accept: application/json"

itarazzo_client:
	mkdir -p reports
	docker run -t --rm \
		--add-host=host.docker.internal:host-gateway \
		-e ARAZZO_FILE=/itarazzo/specs/formal-bnpl.arazzo.yaml \
		-e ARAZZO_INPUTS_FILE=/itarazzo/specs/formal-bnpl-arazzo-inputs.json \
		-v $$PWD/specs:/itarazzo/specs \
		-v $$PWD/reports:/itarazzo/target/reports \
		leidenheit/itarazzo-client

itarazzo_client_error:
	mkdir -p reports
	docker run -t --rm \
		--add-host=host.docker.internal:host-gateway \
		-e ARAZZO_FILE=/itarazzo/specs/error-bnpl.arazzo.yaml \
		-e ARAZZO_INPUTS_FILE=/itarazzo/specs/formal-bnpl-arazzo-inputs.json \
		-v $$PWD/specs:/itarazzo/specs \
		-v $$PWD/reports:/itarazzo/target/reports \
		leidenheit/itarazzo-client

prism-loan-logs:
	docker logs --tail 10 -f prismL


mermaid-to-png:
	sh scripts/generate-images.sh