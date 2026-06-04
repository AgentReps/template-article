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
