#!/usr/bin/env ruby

# options pour séparer .h des .hpp dans src --header_dir
# options pour ajouter pthread sous unix --unix_thread
# options pour juste ajouter le link d'une lib

require 'pathname'

def createSrcDir(location, basename)
	Dir.mkdir(location + "/src")

	f = File.open(location + "/src/main.cpp", 'w')
	f.puts("#include <iostream>")
	f.puts("")
	f.puts("int\tmain()")
	f.puts("{")
	f.puts("\tstd::cout << \"Hello, World!\" << std::endl;")
	f.puts("\treturn 0;")
	f.puts("}")

	f = File.open(location + "/src/" + basename + ".cpp", 'w')
	f.puts("#include \"" + basename + ".hpp\"")
	f.puts("")
	f.puts("using namespace " + basename + ";")
end

def createHeadertDir(location, basename, header_dir)
	if header_dir then
		Dir.mkdir(location + "/header")
		f = File.open(location + "/header/" + basename + ".hpp", 'w')
		f.write("#pragma once\n\nnamespace " + basename + "\n{\n\n\n}\n")
	else
		f = File.open(location + "/src/" + basename + ".hpp", 'w')
		f.write("#pragma once\n\nnamespace " + basename + "\n{\n\n\n}\n")
	end
end

def createCMakeFile(location, basename, unix_thread, libs, header_dir)
	f = File.open(location + '/CMakeLists.txt', 'w')
	f.puts("cmake_minimum_required(VERSION 3.0)")
	f.puts("project(" + basename + ")")
	f.puts("add_definitions(-std=c++14)")
	if unix_thread then
		f.puts("if(UNIX)")
		f.puts("    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -pthread)")
		f.puts("endif(UNIX)")
	end
		f.puts("set(SRCS")
		f.puts("src/main.cpp")
		f.puts("src/" + basename + ".cpp")
		f.puts(")")
	libs.each do |lib|
		f.push("target_link_libraries(" + basename + " " + lib + ")")
	end
	if header_dir then
		f.puts("include_directories(" + basename + " PRIVATE ./header ./test)")
	else
		f.puts("include_directories(" + basename + " PRIVATE ./src ./test)")
	end
	f.puts("add_executable(" + basename + " ${SRCS})")
	f.puts("install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/" + basename + " DESTINATION bin)")
end


def main()
	#default values
	arg_type = :name # possible values :name :incl_lib
	header_dir = false
	unix_thread = false
	libs = []
	name = "HelloWorld"

	# handling arguments
	ARGV.each do|a|
		# options without arguments
		if a == "--header_dir" then
			header_dir = true
		elsif a == "--unix_thread" then
			unix_thread = true
		# set arg_type (options with an argument)
		elsif a == "--include_lib" then
			arg_type = :incl_lib
		# use arg_type (options with an argument)
		elsif arg_type == :name then
			name = a
		elsif arg_type == :incl_lib then
			libs.push(a)
			arg_type = :name
		end
	end

	basename = Pathname.new(name).basename.to_s
	location = './' + Pathname.new(name).dirname.to_s + '/'

	Dir.mkdir(location + basename)
	location += basename + '/'

	puts("Begin")
	createCMakeFile(location, basename, unix_thread, libs, header_dir)
	puts("CMakeList.txt created")
	createSrcDir(location, basename)
	puts("Source directory created")
	createHeadertDir(location, basename, header_dir)
	puts("Header directory created")
	puts("Done")
end

main