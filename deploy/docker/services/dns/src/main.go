package main

import (
    _ "github.com/wealdtech/coredns-ens"
    _ "github.com/coredns/alternate"
	_ "github.com/coredns/coredns/core/plugin"

    "github.com/coredns/coredns/coremain"
    "github.com/coredns/coredns/core/dnsserver"
)

var directives = []string{
    "ens",
    "alternate",

    "any",
    "bind",
    "cache",
    "errors",
    "forward",
    "health",
    "import",
    "local",
    "log",
    "minimal",
    "prometheus",
    "rewrite",
    "template",
}

func init() {
    dnsserver.Directives = directives
}

func main() {
    coremain.Run()
}
