OUT = main
GRAY = gray

all: $(OUT).pdf # $(GRAY).pdf
	pdflatex $(OUT)

full:
	pdflatex $(OUT)
	pdflatex $(OUT)
	bibtex $(OUT)
	pdflatex $(OUT)
	bibtex $(OUT)
	pdflatex $(OUT)

$(OUT).pdf: $(wildcard *.tex *.bib *.bbl *.cls figs/*.eps)
	pdflatex $(OUT)
	bibtex $(OUT)
	pdflatex $(OUT)
	pdflatex $(OUT)

bib:
	bibtex $(OUT)
	pdflatex $(OUT)

clean:
	rm -f *~ *.aux *.dvi *.bbl *.blg *.log
