  head 'https://github.com/etotheipi/BitcoinArmory/archive/master.tar.gz'
  url 'https://github.com/etotheipi/BitcoinArmory/archive/v0.86-beta.tar.gz'
  sha1 '9879f8c0afb964585e7776cd686dcdaaf6adfb83'
  version 'v0.86-beta'

  depends_on 'swig' => :build
  def patches
    DATA
  end

    # my makefile patches weren't working
    system "mkdir -p #{share}/armory/img"
    system "cp *.py *.so README LICENSE #{share}/armory/"
    ArmoryQt.command was installed in
        ln -s #{bin}/ArmoryQt.command ~/Applications/ArmoryQt

    Or you can just run 'ArmoryQt.command' from your terminal

__END__
diff --git a/ArmoryQt.command b/ArmoryQt.command
new file mode 100644
index 0000000..2cc2154
--- /dev/null
+++ b/ArmoryQt.command
@@ -0,0 +1,3 @@
+#!/bin/sh
+PYTHONPATH=`brew --prefix`/lib/python2.7/site-packages /usr/bin/python `brew --prefix`/share/armory/ArmoryQt.py
+