# PkgIndexer

A way to vendor references to packages to be used as a single point of truth about where are the indexes.

Should work in the constrained environment [Nix](https://nixos.org) provides for building but without passing one hash for each package.

This thing should be as lazy as possible to download stuff. If you are using python stuff you shouldn't download NodeJS stuff if you do not need but if you do you will have this option!
