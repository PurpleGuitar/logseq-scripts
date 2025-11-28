# Logseq Scripts

Some handy scripts to use alongside a Logseq vault.

# Installation

Clone or unzip this repo somewhere in your file system. It doesn’t need to
be in your logseq vault.

Set the following environment variables in your shell:

- `LOGSEQ_SCRIPTS_DIR`: the directory where these scripts live.
- `LOGSEQ_BACKUP_DIR`: the directory in which to place backups.

It’s simplest to symlink `makefile` to your vault directory and use `make`
as usual. If you prefer not to do this, you can invoke the file using `-f`
like so:

``` bash
make -f path/to/makefile <target>
```
