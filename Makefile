DUNE := dune
DUNE_PREFIX := _build/default

examples_dir = examples
examples := $(notdir $(wildcard $(examples_dir)/*))

# All targets are phony targets since we want to rely on dune for
# dependency management.

.PHONY : all
all : pattern.opam
	$(DUNE) build runtime/pattern.cmxa
	$(DUNE) build ppx/pattern_ppx.cmxa

.PHONY : clean
clean :
	dune clean

.PHONY : tests
tests :
	$(DUNE) build tests/tests.exe
	$(DUNE_PREFIX)/tests/tests.exe

.PHONY : install
install :
	$(DUNE) build @install
	$(DUNE) install

.PHONY : examples
examples : $(examples)

define foreach_example
.PHONY : $(example)
$(example) :
	$(DUNE) build $(examples_dir)/$(example)/$(example).exe
	$(DUNE_PREFIX)/$(examples_dir)/$(example)/$(example).exe
endef
$(foreach example,$(examples),$(eval $(foreach_example)))

pattern.opam :
	$(DUNE) build pattern.opam
