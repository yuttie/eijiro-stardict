Tool for converting Eijiro dictionary into StarDict one
=======================================================

Requirements
------------

- StarDict tools
- Ruby 2.0 or above

Usage
-----

For example, supposing that you downloaded `EDP-1441.zip`, then you can build a
set of StarDict dictionary files and install them as follows:

~~~sh
$ unzip /path/to/EDP-1441.zip 
$ make
$ mkdir -p ~/.stardict/dic/eijiro/
$ cp EIJI-1441.{dict,idx,ifo} ~/.stardict/dic/eijiro/
~~~
