bigdata
=======

Bigdata is currently a platform for graphical modeling and will support regression analysising in the future.

INSTALL
-------
1. git clone https://github.com/jiangfeng1124/bigdata.git
2. install `django`
3. install `python-mysqldb`
4. install required perl modules for `Circos`, `$CIRCOS/bin/test.modules` can be used to check which modules should be installed. 
5. add `circos` to `$PATH`. for some systems, create a soft link: `/bin/env` for `/usr/bin/env`
6. install R and required R packages: `huge`, `optparse`, `bigmatrix`
7. create a MySQL database named `graphdb`, initialize it using `graphdb.sql`
8. change the **owner** and **group** of the `files/*` directory to `www-data`
