# Cetupp
## Description
Maybe once you had an idea and you wanted to code it in C++, but you were too lazy to write a Makefile or a CMakeList.txt, but you didn't want either to just write "g++ main.cpp yolol.cpp", so finally you didn't code because of this.

With Cetupp you just need to write ./cetupp.rb nameOfYourProject and then a basic CMakeLists.txt is created.

You have few options like separating the headers __--header_lib__ froms other sources or allowing to use thread on Unix (even with the thread from STD most of the time you need it to use threads) __--unix_thread__. You also can link a library with __--lib libName__.

## Prerequisites
You need to have __Ruby installed__ to run the script and then you need __Cmake__ of course because it generates a CMakeLists.txt.

## Potentials problems
The CMakeLists.txt is not perfect, if you want to create a library instead of a binary you need to change the CMakeLists.txt it yourself.

The flag to activate C++14 is set, if your compiler is not up-to-date or if you want C++17 or an another version of the std you must change the CMakeLists.txt yourself.

## Tests
To run launch the script __test.sh__ in the the directory __test__. It's a bash script so you need bash to run it.
