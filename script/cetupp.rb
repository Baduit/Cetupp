#!/usr/bin/env ruby

# option choix de receptable:
# - binaire (defaut) => --bin
# - header only lib => --header_lib
# - classic lib => --lib

# options basiques
# pour tous il faut un nom seul argument qui n'est pas une option
# options pour séparer .h des .hpp dans src --header_dir

# options avancées
# options pour ajouter pthread sous unix --unix_thread
# options pour ajouter des libs de boost --include_boost_lib NOM ou --include_boost_header_lib NOM
# options pour juste ajouter le link d'une lib

# ça consiste à créer les dossiers, créer un/des fichier(s) de base, créer le cmake avec les bonnes règles

require 'pathname'

module DestType
    BIN = 1
    LIB = 2
    HEADER_LIB = 3
end

def createTestDir(location)
    Dir.mkdir(location + "/test");
    f = File.open(location + "/test/test.cpp", 'w')
    f.puts("#include <iostream>")
    f.puts("")
    f.puts("int\tmain()")
    f.puts("{")
    f.puts("\tstd::cout << \"Passed\" << std::endl;")
    f.puts("\treturn 0;")
    f.puts("}")
end

def createSrcDir(location, dest_type, basename)
    Dir.mkdir(location + "/src")
    if dest_type == DestType::BIN then
        f = File.open(location + "/src/main.cpp", 'w')
        f.puts("#include <iostream>")
        f.puts("")
        f.puts("int\tmain()")
        f.puts("{")
        f.puts("\tstd::cout << \"Hello, World!\" << std::endl;")
        f.puts("\treturn 0;")
        f.puts("}")
    elsif dest_type == DestType::LIB then
        f = File.open(location + "/src/" + basename + ".cpp", 'w')
        f.puts("#include \"" + basename + ".hpp\"")
        f.puts("")
        f.puts("using namespace " + basename + ";")
    end
end

def createHeadertDir(location, dest_type, basename, header_dir)
    if header_dir then
        Dir.mkdir(location + "/header")
        if dest_type != DestType::BIN then
            f = File.open(location + "/header/" + basename + ".hpp", 'w')
            f.write("#pragma once\n\nnamespace " + basename + "\n{\n\n\n}\n")
        end
    else
        if dest_type != DestType::BIN then
            f = File.open(location + "/src/" + basename + ".hpp", 'w')
            f.write("#pragma once\n\nnamespace " + basename + "\n{\n\n\n}\n")
        end
    end
end

def createCMakeFile(location, dest_type, basename)
    f = File.open(location + '/CMakeLists.txt', 'w')
    #TO DO
end


def main()
    #default values
    arg_type = :name # possible values :name, :incl_boost_lib, :incl_boost_header_lib, :incl_lib
    dest_type = DestType::BIN
    header_dir = false
    unix_thread = false
    boost_libs = []
    boost_header_libs = []
    libs = []
    name = "HelloWorld"

    # handling arguments
    ARGV.each do|a|
        # dest_type
        if a == "--bin" then
            dest_type = DestType::BIN
        elsif a == "--lib" then
            dest_type = DestType::LIB
        elsif a == "--header_lib" then
            dest_type = DestType::HEADER_LIB
        # options without arguments
        elsif a == "--header_dir" then
            header_dir = true
        elsif a == "--unix_thread" then
            unix_thread = true
        # set arg_type (options with an argument)
        elsif a == "--include_boost_lib" then
            arg_type = :incl_boost_lib
        elsif a == "--include_boost_header_lib" then
            arg_type = :incl_boost_header_lib
        elsif a == "--include_lib" then
            arg_type = :incl_lib
        # use arg_type (options with an argument)
        elsif arg_type == :name then
            name = a
        elsif arg_type == :incl_boost_lib then
            boost_libs.push(a)
            arg_type = :name            
        elsif arg_type == :incl_boost_header_lib then
            boost_header_libs.push(a)
            arg_type = :name
        elsif arg_type == :incl_lib then
            libs.push(a)
            arg_type = :name
        end
    end

    basename = Pathname.new(name).basename.to_s
    location = './' + Pathname.new(name).dirname.to_s + '/'

    Dir.mkdir(location + basename)
    location += basename + '/'

    puts "yeah"

    createCMakeFile(location, dest_type, basename)
    createSrcDir(location, dest_type, basename)
    createHeadertDir(location, dest_type, basename, header_dir)
    createTestDir(location)
end

main