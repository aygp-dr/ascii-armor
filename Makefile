.PHONY: health check tangle export clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

health: ## Run health check
	@./bin/armor-health | python3 -m json.tool 2>/dev/null || ./bin/armor-health

check: ## Validate examples (requires bin/armor-check)
	@test -x bin/armor-check && ./bin/armor-check examples/* || echo "bin/armor-check not yet implemented"

tangle: ## Tangle org files
	emacs --batch -l org --eval "(org-babel-tangle-file \"spec.org\")"
	@test -f mordhau-inline.org && emacs --batch -l org --eval "(org-babel-tangle-file \"mordhau-inline.org\")" || true

export-html: ## Export to HTML
	emacs --batch -l org spec.org -f org-html-export-to-html
	@test -f mordhau-inline.org && emacs --batch -l org mordhau-inline.org -f org-html-export-to-html || true

todo: ## Count remaining TODOs in spec.org
	@echo "TODOs remaining: $$(grep -c TODO spec.org 2>/dev/null || echo 0)"

ready: ## Show unblocked issues
	@bd ready

clean: ## Remove generated files
	rm -f spec.html mordhau-inline.html
	rm -rf /tmp/mordhau-*.jpg
