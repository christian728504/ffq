.PHONY : test check examples build clean push_release

SRR1 = SRR8426358
SRR2 = SRR8426359
SRP1 = SRP178136
SRP2 = SRP096361
GSE1 = GSE135326
GSE2 = GSE124494
DOI1 = 10.1038/s41467-019-08831-9
DOI2 = 10.1016/j.immuni.2019.06.027

test:
	uv run coverage run -m pytest --verbose && uv run coverage report -m

check:
	uv run ruff check ffq && echo OK
	uv run ruff format --check ffq && echo OK

examples:
	uv pip install .
	ffq -o examples/srr_single.json $(SRR1)
	ffq -o examples/srr_multiple.json $(SRR1) $(SRR2)
	ffq -o examples/srr_split --split $(SRR1) $(SRR2)
	ffq -o examples/srp_single.json -t SRP $(SRP1)
	ffq -o examples/srp_multiple.json -t SRP $(SRP1) $(SRP2)
	ffq -o examples/srp_split -t SRP --split $(SRP1) $(SRP2)
	ffq -o examples/gse_single.json -t GSE $(GSE1)
	ffq -o examples/gse_multiple.json -t GSE $(GSE1) $(GSE2)
	ffq -o examples/gse_split -t GSE --split $(GSE1) $(GSE2)
	ffq -o examples/doi_single.json -t DOI $(DOI1)
	ffq -o examples/doi_multiple.json -t DOI $(DOI1) $(DOI2)
	ffq -o examples/doi_split -t DOI --split $(DOI1) $(DOI2)

build:
	uv build

clean:
	rm -rf build
	rm -rf dist
	rm -rf ffq.egg-info
	rm -rf docs/_build
	rm -rf docs/api

bump_patch:
	uv run bump-my-version bump patch

bump_minor:
	uv run bump-my-version bump minor

bump_major:
	uv run bump-my-version bump major

push_release:
	git push && git push --tags
