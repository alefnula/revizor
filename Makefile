.PHONY: help download
.DEFAULT_GOAL := help
PROJECT := revizor


help:                ## Show help.
	@grep -E '^[a-zA-Z2_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


build:               ## Build the frontend.
	@cd app && flutter build web --release

run:                 ## Run the backend.
	uvicorn revizor.main:app --reload

