.PHONY: all clean test

bump-check:
	# Check what the next version is without making any changes
	cz bump --yes --changelog --annotated-tag --dry-run --allow-no-commit

bump-major:
	# Automatically bump the major version
	cz bump --yes --changelog --annotated-tag --increment major

bump-minor:
	# Automatically bump the minor version
	cz bump --yes --changelog --annotated-tag --increment minor

bump-patch:
	# Automatically bump the patch version
	cz bump --yes --changelog --annotated-tag --increment patch

bump:
	# Automatically determine the next version and create a new tag
	cz bump --yes --changelog --annotated-tag

changelog:
	# Generate or update the changelog
	cz changelog

validate-commits:
	# Validate commit messages according to Conventional Commits
	cz check
