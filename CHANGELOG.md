# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 0.2.0 [Unreleased]

* Remove absolute values from metric reports
* Support block syntax for `trigger!` to narrow metric changes
* Add tracking of memory usage of a specific object (`Mnemonic.new() { |c| c.memsize_of(obj) }`)
