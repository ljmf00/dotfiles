module ljmf00.app.java.environment;

import std.process;
import std.format;

/// default Java path
enum DEFAULT_JAVA_PATH = "/usr/lib/jvm/default/";

@safe nothrow
string javaPath() @property
{
    try
    {
        auto ret = execute(["archlinux-java", "get"]);

        if (ret.status != 0)
            return DEFAULT_JAVA_PATH;

        return format!"/usr/lib/jvm/%s"(ret.output);
    }
    catch(Exception)
        return DEFAULT_JAVA_PATH;
}
