#
PROJECT := FETCHDB
PROGRAM := $(PROJECT)

COPYLIBDIR := ../../copylib
PSQL_OPTIONS :=

RESULT_FILE := result.txt

$(PROGRAM): $(PROGRAM).COB
	cobc -x -I$(COPYLIBDIR) -I. -Q "-Wl,--no-as-needed" -locsql -o $@ $<

$(PROGRAM).COB: $(PROGRAM).CBL USERS.cpy
	esqlOC -Q -I $(COPYLIBDIR) -I . -o $@ $<

.PHONY: run
run: $(PROGRAM)
	OTF=$(RESULT_FILE) ./$(PROGRAM)


.PHONY: clean
clean:
	@rm -rf $(PROGRAM) $(PROGRAM).COB $(RESULT_FILE)
