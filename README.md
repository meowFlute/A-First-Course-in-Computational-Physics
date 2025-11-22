# A First Course in Computational Physics
by Paul L. DeVries (published in 1994)

## What is this repo?
As simple as me working through a textbook for fun. Not really intended to be useful for anyone but me.

This book is all about Fortran, so I imagine that is mostly what this repo will contain when I finish the book or move on to some other interest

## Plotting submodule
A lot has changed in the field of scientific plotting since this book was published in the early 90s.

The book has details about a labor-intensive, low-levl method of plotting that utilized functions available in the Microsoft FORTRAN Version 5.0 Compiler,
which was released in 1989 and added support for OS/2 1.1 and the 386 processor. [Here is a review of the compiler in a the May 15, 1989 InfoWorld.](https://books.google.com/books?id=UDoEAAAAMBAJ&pg=PA711&dq=microsoft+fortran&hl=en&sa=X&ved=0ahUKEwjV8aXe_pHNAhVBSiYKHUArAbQQ6AEIRzAH#v=onepage&q&f=false)
 [Here is where you can download the compiler](https://winworldpc.com/product/microsoft-fortran/5x) 

I don't really want to mess around with that just yet. I'm using modern fortran (through the gnu toolchain) and plan to plot with gnuplot.

As such, I've added [this repo](https://github.com/jchristopherson/fplot) as a submodule.

### Building the plotting submodule
I'm not sure of how this would work on every machine, but here are some notes for myself. You could do the following after a clone of this repo if you didn't already initialize submodules:

```shell
$ git submodule update --init
```

then to use the submodule, you just change into the directory and build it with cmake (using the options present in the lists file as you wish)

```shell
$ cd fplot
$ mkdir -p build
$ cmake -DBUILD_TESTING=ON -DBUILD_FPLOT_EXAMPLES=ON -B build/
$ cd build
$ make
```

at that point, (assuming dependencies are present) you have a library you should be able to just link in located here

```shell
# from the computational physics book repo root folder
$ ls fplot/build/src/
libfplot.a
```

with examples and tests and things also built up
