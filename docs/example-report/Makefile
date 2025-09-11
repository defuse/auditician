audit-report.pdf: audit-report.tex audit-report.bib
	pdflatex audit-report.tex
	bibtex audit-report
	pdflatex audit-report.tex
	pdflatex audit-report.tex

.PHONY: clean
clean:
	rm -f audit-report.pdf *.bbl *.blg *.log *.aux *.toc *.out
