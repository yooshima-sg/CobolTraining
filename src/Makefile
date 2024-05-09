PROGS := KCBS010.so KJBM010 KJBM020 KJBM030 KJBM040 KJBM050 KJBM060 KUBM010 KUBM020 KUBM030A KUBM030B KUBM040

all: $(PROGS)

KCBS010.so: KCBS010.COB
	cobc -m -o $@ -I ../copylib $<

KJBM010: KJBM010.COB
	cobc -x -o $@ -I ../copylib $<

KJBM020: KJBM020.COB
	cobc -x -o $@ -I ../copylib $<

KJBM030: KJBM030.COB
	cobc -x -o $@ -I ../copylib $<

KJBM040: KJBM040.COB
	cobc -x -o $@ -I ../copylib $<

KJBM050: KJBM050.COB
	cobc -x -o $@ -I ../copylib $<

KJBM060: KJBM060.COB
	cobc -x -o $@ -I ../copylib $<

KUBM010: KUBM010.COB
	cobc -x -o $@ -I ../copylib $<

KUBM020: KUBM020.COB
	cobc -x -o $@ -I ../copylib $<

KUBM030A.COB: KUBM030A.CBL
	ocesql $< $@

KUBM030A: KUBM030A.COB
	cobc -x -I../copylib -Q "-Wl,--no-as-needed" -locesql -I/usr/local/ocesql/copy -o $@ $<

KUBM030B.COB: KUBM030B.CBL
	esqlOC -Q -I ../copylib -o $@ $<

KUBM030B: KUBM030B.COB
	cobc -x -I../copylib -Q "-Wl,--no-as-needed" -locsql -o $@ $<

KUBM040: KUBM040.COB
	cobc -x -o $@ -I ../copylib $<

.PHONY: clean
clean:
	@rm -rf $(PROGS) KUBM030A.COB KUBM030B.COB
