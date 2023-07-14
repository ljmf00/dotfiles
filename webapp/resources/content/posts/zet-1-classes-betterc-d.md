---
title: 'Zettelkasten #1: Classes in D with betterC'
date: '2021-11-15T00:07:00+01:00'
tags: ['zettelkasten', 'zet', 'dlang', 'betterc', 'classes']
---

This post describes the problem with not having D classes in
betterC and both present tricky and reasonable solutions on how to use classes
with C++ linkage in D with betterC.

---

Did you know that you can use classes in D as better C? Yes, you read
correctly, you can actually use classes in D with `-betterC`.

## Problem involved

The main problem with having normal classes in D as better C is the dependency
of runtime hooks and runtime type information from the D runtime library. Since
betterC has some limitations, including forbidden usage of runtime type
information, users are usually stuck with features from D that doesn't use the
runtime. Although, on the other hand, betterC doesn't limit the usage of C and
C++ linkage, since they are not dependent on any runtime library.

## What is the tricky part?

There are tricky parts involved in instantiating `extern(C++)` classes,
however.  At the time of this post, with the latest version of the compiler, is
not easily possible to fetch the init memory block of a class without:

1. Rely on the `TypeInfo` (use `typeid(ClassFoo).initializer`)
2. Create a dummy `scope` instance of the class and copy the memory to a newly
   allocated buffer.

Both these options have drawbacks and the first one is only possible on
`betterC` if we manually create and remove some symbols.

The second option is also limitative since the user is not able to use the
normal class destructor. If you don't use any special destructor, you can
easily fetch that class initializer with something like this:

```d
static auto initializer()
{
    alias T = typeof(this);
    void[__traits(classInstanceSize, T)] t = void;
    scope T s = new T;
    t[] = (cast(void*)s)[0 .. t.length];
    return t;
}
```

You can also circumvent this issue by using a custom destructor, although you
won't benefit from the
[RAII](https://ipfs.io/ipfs/bafybeiemxf5abjwjbikoz4mc3a3dla6ual3jsgpdr4cjr3oz3evfyavhwq/wiki/Resource_Acquisition_Is_Initialization.html)
idiom.

## A reasonable solution

Fortunately, LDC has a compiler trait called `__traits(initSymbol)`, which will
be soon described by the D specification and
[implemented](https://github.com/dlang/dmd/pull/13298) by the reference
compiler (DMD) that can do exactly that, fetch the initializer of a class type.

You just need to create custom allocate and destroy function templates:

```d
T alloc(T, Args...)(auto ref Args args)
{
    enum tsize = __traits(classInstanceSize, T);
    T t = () @trusted {
        import core.memory : pureMalloc;
        auto _t = cast(T)pureMalloc(tsize);
        if (!_t) return null;
        import core.stdc.string : memcpy;
        memcpy(cast(void*)_t, __traits(initSymbol, T).ptr, tsize);
        return _t;
    } ();
    if(!t) return null;
    import core.lifetime : forward;
    t.__ctor(forward!args);

    return t;
}

void destroy(T)(ref T t)
{
    static if (__traits(hasMember, T, "__xdtor"))
        t.__xdtor();
    import core.memory : pureFree;
    pureFree(cast(void*)t);
    static if (__traits(compiles, { t = null; }))
        t = null;
}
```

With those two functions you can now just allocate a new class instance:

```d
extern(C++) class Foo
{
    this(int a, float b)
    {
        this.a = a * 2;
        this.b = b;
    }

    int a;
    float b;
    bool c = true;
}

extern(C) int main()
{
    Foo foo = alloc!Foo(2, 2.0f);
    scope(exit) destroy(foo);

    int a = foo.a;   // 4
    float b = foo.b; // 2.0
    bool c = foo.c;  // true

    return 0;
}
```

Please note that I haven't covered every corner case about classes with this
example.
