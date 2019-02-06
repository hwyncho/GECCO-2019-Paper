PACKAGE = acmart
MAIN = main

pdf: $(PACKAGE).pdf $(MAIN).pdf
all: $(PACKAGE).cls $(PACKAGE).pdf $(MAIN).pdf


$(PACKAGE).cls: $(PACKAGE).ins $(PACKAGE).dtx
	pdflatex $<

$(PACKAGE).pdf: $(PACKAGE).dtx $(PACKAGE).cls
	pdflatex $<
	- bibtex $(PACKAGE)
	pdflatex $<
	- makeindex -s gind.ist -o $(PACKAGE).ind $(PACKAGE).idx
	- makeindex -s gglo.ist -o $(PACKAGE).gls $(PACKAGE).glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' acmart.log) \
	do pdflatex $<; done

$(MAIN).pdf: $(MAIN).tex $(PACKAGE).cls ACM-Reference-Format.bst
	pdflatex $<
	- bibtex $(MAIN)
	pdflatex $<
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' main.log) \
	do pdflatex $<; done

clean:
	$(RM) *.log *.aux *.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof *.lot *.bbl *.blg \
	*.gls *.cut *.hd *.dvi *.thm *.rpi *-converted-to.pdf
