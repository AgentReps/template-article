OUTDIR     := output
LATEX      := pdflatex
BIBTEX     := bibtex
LATEXFLAGS := -interaction=nonstopmode -halt-on-error

MAIN := main
PDF  := $(OUTDIR)/$(MAIN).pdf

OPEN := open

.PHONY: all view clean

all: $(PDF)

$(PDF): $(MAIN).tex templates/preamble.tex $(wildcard sections/*.tex) $(wildcard *.bib)
	mkdir -p $(OUTDIR)
	TEXINPUTS=.:templates/: $(LATEX) $(LATEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	-cd $(OUTDIR) && BIBINPUTS=.. BSTINPUTS=../templates: $(BIBTEX) $(MAIN)
	TEXINPUTS=.:templates/: $(LATEX) $(LATEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	TEXINPUTS=.:templates/: $(LATEX) $(LATEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex

view: $(PDF)
	$(OPEN) $(PDF)

clean:
	rm -f $(OUTDIR)/$(MAIN).bbl \
	      $(OUTDIR)/$(MAIN).blg \
	      $(OUTDIR)/$(MAIN).log \
	      $(OUTDIR)/$(MAIN).toc \
	      $(OUTDIR)/$(MAIN).lof \
	      $(OUTDIR)/$(MAIN).lot \
	      $(OUTDIR)/$(MAIN).out \
	      $(OUTDIR)/$(MAIN).fls \
	      $(OUTDIR)/$(MAIN).fdb_latexmk \
	      $(OUTDIR)/$(MAIN).synctex.gz \
	      $(OUTDIR)/$(MAIN).aux \
	      $(OUTDIR)/$(MAIN).pdf
