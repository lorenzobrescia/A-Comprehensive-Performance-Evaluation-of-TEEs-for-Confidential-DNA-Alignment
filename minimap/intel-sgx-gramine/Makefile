all: mini.manifest.sgx mini.sig

mini.manifest: manifest.template
	gramine-manifest \
		-Darch_libdir="/lib/x86_64-linux-gnu/" \
		-Dths=$(ths) \
		$< >$@

mini.manifest.sgx mini.sig: sgx_sign
	@:

.INTERMEDIATE: sgx_sign
sgx_sign: mini.manifest
	gramine-sgx-sign \
		--manifest $< \
		--output $<.sgx

clean:
	rm sample.sam *.sig *.manifest *.sgx
