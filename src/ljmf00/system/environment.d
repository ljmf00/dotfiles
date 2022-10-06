module ljmf00.system.environment;

import core.sys.posix.unistd;

enum DEFAULT_PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";

string currentUser() @property
{
    char[255] user;

    auto ret = getlogin_r(user.ptr, user.length);
    if (ret == 0)
        return user.idup;

    return null;
}
