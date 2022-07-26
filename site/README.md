# ClonMapper Protocol Website

The website for the ClonMapper protocol is based on [hugo](https://gohugo.io).

## Adding archived versions

To add an archived version of the protocol first copy the pdf into `static/pdfs/`.
Then in `data/archive` create a new `.toml` file with information about the
version including an optional title field, otherwise the name of the file will be used.

For example:

`2022.07.15-a9a0655.toml`:
```toml
date = "2022.07.10"
file = "clonmapper-protocol-2022.07.15-a9a0655.pdf"
title = "An Important Version."
```


TODO:

- [ ] add a page for the plasmid maps (link to addgene for image?)
- [ ] drop mathjax for already builtin katex
