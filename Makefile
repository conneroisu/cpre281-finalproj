
run: 
	questasim proj/
report:
	rm -f README2.md
	cp README.md README2.md
	sh run.sh README2.md -n="cpre281-finalproj"
	xdg-open ./README2.html
	rm -f README2.md
