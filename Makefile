CLASSES=\
	ampersand-class-extend.js \
	ampersand-dom.js \
	ampersand-dom-bindings.js \
	ampersand-view.js \
	ampersand-events.js \
	ampersand-model.js \
	ampersand-rest-collection.js \
	ampersand-collection-rest-mixin.js \
	ampersand-collection.js \
	ampersand-collection-view.js \
	ampersand-collection-lodash-mixin.js \
	ampersand-state.js \
	ampersand-sync.js \
	key-tree-store.js \
	array-next.js
ES5CLASSES=$(addprefix es5/, $(CLASSES)) es5/main.js

TESTS=\
	test/ampersand-class-extend.js \
	test/ampersand-collection-lodash-mixin.js \
	test/ampersand-collection-rest-mixin.js \
	test/ampersand-dom.js \
	test/ampersand-dom-bindings.js \
	test/ampersand-model.js \
	test/ampersand-events.js \
	test/ampersand-collection.js \
	test/ampersand-collection-view.js \
	test/ampersand-rest-collection.js \
	test/ampersand-state--basics.js \
	test/ampersand-state--full.js \
	test/ampersand-sync--unit.js \
	test/ampersand-sync--integration.js \
	test/ampersand-view--main.js \
	test/ampersand-view--renderCollection.js \
	ampersand-sync.js \
	test/key-tree-store.js \
	test/array-next.js

BROWSERIFY=./node_modules/.bin/browserify
TAPE_RUN=./node_modules/.bin/tape-run
BABEL=./node_modules/.bin/babel

all: $(CLASSES) $(TESTS) $(ES5CLASSES)

clean:
	-rm -rf $(CLASSES) $(TESTS) $(ES5CLASSES) libs utils

es5/%.js: %.js
	mkdir -p es5
	$(BABEL) $< -o $@

ampersand-class-extend.js: source/ampersand-class-extend/ampersand-class-extend.js
	./process $< > $@

test/ampersand-class-extend.js: source/ampersand-class-extend/test/main.js 
	./process $< > $@

ampersand-dom.js: source/ampersand-dom/ampersand-dom.js
	./process $< > $@

test/ampersand-dom.js: source/ampersand-dom/test/index.js 
	./process $< > $@

ampersand-collection-lodash-mixin.js: source/ampersand-collection-lodash-mixin/ampersand-collection-lodash-mixin.js
	./process $< > $@

test/ampersand-collection-lodash-mixin.js: source/ampersand-collection-lodash-mixin/test/index.js 
	./process $< > $@

ampersand-collection-rest-mixin.js: source/ampersand-collection-rest-mixin/ampersand-collection-rest-mixin.js
	./process $< > $@

test/ampersand-collection-rest-mixin.js: source/ampersand-collection-rest-mixin/test/main.js 
	./process $< > $@

ampersand-rest-collection.js: source/ampersand-rest-collection/ampersand-rest-collection.js
	./process $< > $@

test/ampersand-rest-collection.js: source/ampersand-rest-collection/test/main.js 
	./process $< > $@

ampersand-view.js: source/ampersand-view/ampersand-view.js
	./process $< > $@

test/ampersand-view--main.js: source/ampersand-view/test/main.js 
	./process $< > $@

test/ampersand-view--renderCollection.js: source/ampersand-view/test/renderCollection.js 
	./process $< > $@

ampersand-collection-view.js: source/ampersand-collection-view/ampersand-collection-view.js
	./process $< > $@

test/ampersand-collection-view.js: source/ampersand-collection-view/test/index.js 
	./process $< > $@

ampersand-model.js: source/ampersand-model/ampersand-model.js
	./process $< > $@

test/ampersand-model.js: source/ampersand-model/test/index.js 
	./process $< > $@

ampersand-collection.js: source/ampersand-collection/ampersand-collection.js
	./process $< > $@

test/ampersand-collection.js: source/ampersand-collection/test/main.js 
	./process $< > $@

ampersand-events.js: source/ampersand-events/ampersand-events.js source/ampersand-events/libs/utils.js
	./process $< > $@
	mkdir -p libs
	./process source/ampersand-events/libs/utils.js > libs/utils.js

test/ampersand-events.js: source/ampersand-events/test/index.js 
	./process $< > $@

ampersand-state.js: source/ampersand-state/ampersand-state.js
	./process $< > $@

test/ampersand-state--basics.js: source/ampersand-state/test/basics.js 
	./process $< > $@

test/ampersand-state--full.js: source/ampersand-state/test/full.js 
	./process $< > $@

ampersand-sync.js: source/ampersand-sync/ampersand-sync-browser.js source/ampersand-sync/core.js
	./process $< > $@
	./process source/ampersand-sync/core.js > core.js

test/ampersand-sync--unit.js: source/ampersand-sync/test/unit.js
	./process $< > $@
	rsync -avz source/ampersand-sync/test/helpers/ test/helpers/

test/ampersand-sync--integration.js: source/ampersand-sync/test/integration.js 
	./process $< | sed -e "s/'\.\.\/'/'..\/ampersand-sync'/g" > $@
	rsync -a source/ampersand-sync/test/helpers/ test/helpers/

array-next.js: source/array-next/array-next.js
	./process $< > $@

test/array-next.js: source/array-next/test.js
	./process $< > $@

ampersand-dom-bindings.js: source/ampersand-dom-bindings/ampersand-dom-bindings.js
	./process $< > $@

test/ampersand-dom-bindings.js: source/ampersand-dom-bindings/test/index.js 
	./process $< > $@

key-tree-store.js: source/key-tree-store/key-tree-store.js
	./process $< > $@

test/key-tree-store.js: source/key-tree-store/test/index.js 
	./process $< > $@

check:
	for test in $(TESTS); do \
		PATH=./node_modules/.bin:$$PATH $(BROWSERIFY) -t babelify $$test | $(TAPE_RUN); \
	done
