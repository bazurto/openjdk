version=16.0.2
name=openjdk

# Edit
linux_orig_url=https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-$(version)_linux-x64_bin.tar.gz
linux_orig_zip_name=openjdk-$(version)_linux-x64_bin.tar.gz

windows_orig_url=https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-$(version)_windows-x64_bin.zip
windows_orig_zip_name=openjdk-$(version)_windows-x64_bin.zip

darwin_orig_url=https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-$(version)_osx-x64_bin.tar.gz
darwin_orig_zip_name=openjdk-$(version)_osx-x64_bin.tar.gz
# Edit end


linux_dir_name=$(name)-linux-amd64-v$(version)
linux_zip_name=$(linux_dir_name).zip

windows_dir_name=$(name)-windows-amd64-v$(version)
windows_zip_name=$(windows_dir_name).zip

darwin_dir_name=$(name)-darwin-amd64-v$(version)
darwin_zip_name=$(darwin_dir_name).zip



.PHONY: build release

build: $(linux_zip_name) $(windows_zip_name) $(darwin_zip_name)

release: $(linux_zip_name) $(windows_zip_name) $(darwin_zip_name)
	gh release create -t v$(version) --notes v$(version) v$(version) $(linux_zip_name) $(windows_zip_name) $(darwin_zip_name)

$(linux_zip_name): $(linux_dir_name)
	cd $(linux_dir_name) && zip -r -y ../$(linux_zip_name) .
$(linux_dir_name): $(linux_orig_zip_name)
	rm -fr jdk-$(version) $(linux_dir_name)_tmp
	tar xvf $(linux_orig_zip_name)
	mv jdk-$(version) $(linux_dir_name)_tmp
	$(linux_dir_name)_tmp/bin/keytool -import \
			-alias ca.starbucksdev.goskope.com.crt \
			-file certs/ca.starbucksdev.goskope.com.crt \
			-storepass changeit -noprompt \
			-keystore $(linux_dir_name)_tmp/lib/security/cacerts 
	$(linux_dir_name)_tmp/bin/keytool -import \
			-alias caadmin.netskope.com.crt \
			-file certs/caadmin.netskope.com.crt \
			-storepass changeit -noprompt \
			-keystore $(linux_dir_name)_tmp/lib/security/cacerts 
	mv $(linux_dir_name)_tmp $(linux_dir_name)
$(linux_orig_zip_name):
	wget $(linux_orig_url)


$(windows_zip_name): $(windows_dir_name)
	cd $(windows_dir_name) && zip -r -y ../$(windows_zip_name) .
$(windows_dir_name): $(windows_orig_zip_name) $(linux_dir_name)
	rm -fr jdk-$(version) $(windows_dir_name)_tmp
	unzip $(windows_orig_zip_name)
	mv jdk-$(version) $(windows_dir_name)_tmp
	./$(linux_dir_name)/bin/keytool -import \
			-alias ca.starbucksdev.goskope.com.crt \
			-file certs/ca.starbucksdev.goskope.com.crt  \
			-storepass changeit -noprompt \
			-keystore $(windows_dir_name)_tmp/lib/security/cacerts 
	./$(linux_dir_name)/bin/keytool -import \
			-alias caadmin.netskope.com.crt \
			-file certs/caadmin.netskope.com.crt \
			-storepass changeit -noprompt \
			-keystore $(windows_dir_name)_tmp/lib/security/cacerts 
	mv $(windows_dir_name)_tmp $(windows_dir_name)
$(windows_orig_zip_name):
	wget $(windows_orig_url)

$(darwin_zip_name): $(darwin_dir_name)
	cd $(darwin_dir_name) && zip -r -y ../$(darwin_zip_name) .
$(darwin_dir_name): $(darwin_orig_zip_name) $(linux_dir_name)
	rm -fr jdk-$(version).jdk $(darwin_dir_name)_tmp
	tar xvf $(darwin_orig_zip_name)
	mv jdk-$(version).jdk/Contents/Home $(darwin_dir_name)_tmp
	./$(linux_dir_name)/bin/keytool -import \
			-alias ca.starbucksdev.goskope.com.crt \
			-file certs/ca.starbucksdev.goskope.com.crt \
			-storepass changeit -noprompt \
			-keystore $(darwin_dir_name)_tmp/lib/security/cacerts 
	./$(linux_dir_name)/bin/keytool -import \
			-alias caadmin.netskope.com.crt \
			-file certs/caadmin.netskope.com.crt \
			-storepass changeit -noprompt \
			-keystore $(darwin_dir_name)_tmp/lib/security/cacerts 
	mv $(darwin_dir_name)_tmp $(darwin_dir_name)
$(darwin_orig_zip_name):
	wget $(darwin_orig_url)


.PHONY: clean release

clean:
	rm -fr \
		$(linux_dir_name) $(linux_zip_name) $(linux_orig_zip_name) \
		$(windows_dir_name) $(windows_zip_name) $(windows_orig_zip_name) \
		$(darwin_dir_name) $(darwin_zip_name) $(darwin_orig_zip_name) \
		jdk-$(version) jdk-$(version).jdk

