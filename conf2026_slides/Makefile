OUTDIR     := output
LATEX      := pdflatex
LATEXFLAGS := -interaction=nonstopmode -halt-on-error

MAIN := main
PDF  := $(OUTDIR)/$(MAIN).pdf

OPEN := open

.PHONY: all view clean

all: $(PDF)

$(PDF): $(MAIN).tex ../templates/preamble.tex
	mkdir -p $(OUTDIR)
	TEXINPUTS=.:../templates/: $(LATEX) $(LATEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	TEXINPUTS=.:../templates/: $(LATEX) $(LATEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex

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
	      $(OUTDIR)/$(MAIN).nav \
	      $(OUTDIR)/$(MAIN).snm \
	      $(OUTDIR)/$(MAIN).vrb \
	      $(OUTDIR)/$(MAIN).pdf
