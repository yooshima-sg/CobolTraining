#
PROJECT := FETCHDB
PROGRAM := $(PROJECT)
PSQL_OPTIONS :=

.PHONY: build
build: $(PROGRAM)

$(PROGRAM): $(PROGRAM).COB
	cobc -x -I../../copylib -I. -Q "-Wl,--no-as-needed" -locsql -o $@ $<

$(PROGRAM).COB: $(PROGRAM).CBL USERS.cpy USERS-DECLARE.cpy
	esqlOC -Q -I ../../copylib -I . -o $@ $<

.PHONY: clean
clean:
	@rm -rf $(PROGRAM) $(PROGRAM).COB
