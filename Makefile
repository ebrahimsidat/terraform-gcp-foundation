fmt:
	terraform fmt -recursive

validate:
	for dir in modules/* examples/*; do terraform -chdir="$$dir" init -backend=false -input=false >/dev/null && terraform -chdir="$$dir" validate || exit 1; done

lint:
	tflint --recursive --config "$$(pwd)/.tflint.hcl"

security:
	checkov --directory . --framework terraform --quiet --compact

check: validate lint security
	terraform fmt -check -recursive

.PHONY: fmt validate lint security check
