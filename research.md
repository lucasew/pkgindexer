# Research on the subject

Put here research about where to get given information about each index

# What we have
* Pypi (python)
    - **Metadata**: https://pypi.org/pypi/{name}/json
    - **Hash supported**: MD5
    - No way to get a full dump of the index
    - Repology can give a 60MB zstd JSON but it's always the latest revision
    - [ ] Find a way to download an full index of the packages
    - [ ]  Find a way to automate the index updates
* NPM (js/ts/...)
    - **Metadata**: https://registry.npmjs.org/{name}
    - **Hash supported**: SHA1
    - [ ]  Find a way to automate the index of the packages
    - [ ]  Find a way to automate the index updates
* MELPA (elisp)
    - **Metadata**: https://melpa.org/recipes.json
    - References git repos, no version management
    - [ ]  Analyse what should be done in this case
    - [ ]  Find inspiration on the approach nixpkgs is using
* Cargo (rust)
    - **Metadata**: https://crates.io/api/v1/crates/{name}/versions
    - **Metadata repo**: https://github.com/rust-lang/crates.io-index/
    - **Hash supported**: SHA256
    - **Aprox metadata size**: ~50MB
    - I think we have everything we need, just pin the definition repo and start using
    - OBS
        - Has metadata endpoint but it's better to use via the vendorized github index
        - Cargo.lock has a sha256 hash of every dependency and the download url can be infered from the data already provided
        - The metadata repo uses subdirectories for better tree management
        -  Ex: [Solana](https://github.com/rust-lang/crates.io-index/blob/master/so/la/solana)
* RubyGems (ruby)
    - **Metadata**: https://rubygems.org/api/v1/versions/{name}.json
    - **Download** https://rubygems.org/gems/{name}-{version}.gem
    - **Hash supported**: SHA256
    - [ ]  find a way to dump the index with versions
    - [ ]  find a way to automate minor bumps
    - [ ]  find a way to parse dependencies
* OPAM (OCaml)
    - Pseudoapi: https://github.com/ocaml/opam-repository
    - [ ]  parse dependency metadata from the format used by ocaml
    - [ ]  find a way to dump the index with versions

# What is missing yet
- [ ] Repos
    - [ ]  Maven (JVM)
    - [ ]  Hackage (haskell)
    - [ ]  VSCode extensions
    - [ ]  Pub (dart/flutter)
    - [ ]  Hex (elixir/erlang)
