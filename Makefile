.PHONY: %
ci: lint format-check cloc
lint: lint_debootstrap-jr lint_strip-debootstrap lint_Dockerfile
format-check: format-check_debootstrap-jr format-check_strip-debootstrap
format: format_debootstrap-jr format_strip-debootstrap
cloc:
	cloc . --by-file
lint_%:
	shellcheck $*
format-check_%:
	shfmt --diff $*
format_%:
	shfmt --write $*
