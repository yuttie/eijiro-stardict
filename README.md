Tool for converting Eijiro dictionary into StarDict one
=======================================================

Requirements
------------

- StarDict tools
- Ruby 2.0 or above

Usage
-----

~~~sh
$ ruby text2tabfile.rb EIJIRO/EIJI-1441.TXT > EIJI-1441.tabfile
$ stardict_tabfile EIJI-1441.tabfile
$ sed -i 's/sametypesequence=m/sametypesequence=g/' EIJI-1441.ifo
$ cp EIJI-1441.{dict,idx,ifo} ~/.stardict/dic/eijiro/
~~~
