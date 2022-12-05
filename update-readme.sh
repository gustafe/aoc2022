#!/usr/bin/bash

cat README.head

for f in `ls -r d*.pl`
do
    pod2markdown ${f}
    echo '---'
done

	 
	 
