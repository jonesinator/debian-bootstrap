.PHONY: %
ci: lint format-check
lint: lint_bootstrap lint_cleanup-debootstrap lint_Containerfile
format-check: format-check_bootstrap format-check_cleanup-debootstrap
format: format_bootstrap format_cleanup-debootstrap
lint_%:
	shellcheck $*
format-check_%:
	shfmt --diff $*
format_%:
	shfmt --write $*
