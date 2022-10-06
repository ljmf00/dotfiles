module ljmf00.shell.aliases;

string[string] aliasCommands()
{
    return [
        "l"     : "ls -lah",
        "la"    : "ls -lAh",
        "ll"    : "ls -lh",
        "lsa"   : "ls -lah",

        "ip"    : "ip -color=auto",
        "dmesg" : "dmesg --color=always",

        "e"     : defaultEditor,
        "v"     : defaultEditor,
    ];
}
