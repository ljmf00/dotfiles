module ljmf00.environment;

import ljmf00.app.java.environment;
import ljmf00.system.environment;

import std.path;
import std.process;

string[string] defaultEnvironment()
{
    return [
        "USER"               : environment.get("USER", currentUser),
        "TERM"               : fallbackTerminal,
        "PATH"               : format!"%s:%s"(
            expandTilde("~/.local/bin"),
            environment.get("PATH", DEFAULT_PATH),
        ),

        "PS1"                : `[\u@\h \W]\$ `,

        "EDITOR"             : defaultEditor,
        "VISUAL"             : defaultEditor,

        "JAVA_HOME"          : environment.get("JAVA_HOME", javaPath),
        "JBOSS_HOME"         : environment.get("JBOSS_HOME", "/opt/wildfly"),

        "WINEPREFIX"         : environment.get("WINEPREFIX", expandTilde("~/.wine")),
        "WINEARCH"           : environment.get("WINEARCH", "win64"),

        "USE_CCACHE"         : environment.get("USE_CCACHE", "1"),
        "CCACHE_COMPRESS"    : environment.get("CCACHE_COMPRESS", "1"),

        "AWS_DEFAULT_REGION" : "eu-west-1",
        "AWS_REGION"         : "eu-west-1",
    ];
}
