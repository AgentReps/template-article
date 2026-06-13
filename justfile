# Build configuration
outdir     := "output"
latex      := "pdflatex"
bibtex     := "bibtex"
latexflags := "-interaction=nonstopmode -halt-on-error"
main       := "main"
open_cmd   := "open"

# Print available recipes (default recipe)
default:
    @just --list

# Print available recipes
list:
    @just --list

# Full build: pdflatex -> bibtex -> pdflatex -> pdflatex
build:
    mkdir -p {{outdir}}
    TEXINPUTS=.:templates/: {{latex}} {{latexflags}} -output-directory={{outdir}} {{main}}.tex
    -cd {{outdir}} && BIBINPUTS=.. BSTINPUTS=../templates: {{bibtex}} {{main}}
    TEXINPUTS=.:templates/: {{latex}} {{latexflags}} -output-directory={{outdir}} {{main}}.tex
    TEXINPUTS=.:templates/: {{latex}} {{latexflags}} -output-directory={{outdir}} {{main}}.tex

# Open the compiled PDF
view: build
    {{open_cmd}} {{outdir}}/{{main}}.pdf

# Remove build artifacts
clean:
    rm -f {{outdir}}/{{main}}.bbl \
          {{outdir}}/{{main}}.blg \
          {{outdir}}/{{main}}.log \
          {{outdir}}/{{main}}.toc \
          {{outdir}}/{{main}}.lof \
          {{outdir}}/{{main}}.lot \
          {{outdir}}/{{main}}.out \
          {{outdir}}/{{main}}.fls \
          {{outdir}}/{{main}}.fdb_latexmk \
          {{outdir}}/{{main}}.synctex.gz \
          {{outdir}}/{{main}}.aux \
          {{outdir}}/{{main}}.pdf

# List the papers in the local arXiv library (resources/)
resources:
    #!/usr/bin/env bash
    shopt -s nullglob
    dirs=(resources/arXiv-*/)
    if [ ${#dirs[@]} -eq 0 ]; then
        echo "No papers in resources/ yet — ingest one with the get-arxiv skill."
        exit 0
    fi
    echo "Local arXiv library — ${#dirs[@]} paper(s):"
    for d in "${dirs[@]}"; do
        s="${d}SUMMARY.md"
        title=$(sed -n 's/^title:[[:space:]]*//p' "$s" 2>/dev/null | head -1)
        if [ -z "$title" ]; then
            title=$(sed -n 's/^# //p' "$s" 2>/dev/null | head -1)
        fi
        if [ -z "$title" ]; then
            title="(no SUMMARY.md)"
        fi
        id=$(basename "$d")
        printf '  %-22s %s\n' "${id#arXiv-}" "$title"
    done
    echo "(roles & tags: resources/CATALOG.md)"
