#!/usr/bin/env ruby

# option choix de receptable:
# - binaire (defaut) => --bin
# - header only lib => --header_lib
# - classic lib => --lib

# options basiques
# pour tous il faut un nom seul argument qui n'est pas une option
# options pour séparer .h des .hpp dans src --header_dir
# options pour désact un module de test --test et --no_test pour désactiver

# options avancées
# options pour ajouter pthread sous unix --unix_thread
# options pour ajouter des libs de boost --include_boost_lib NOM ou --include_boost_header_lib NOM
# options pour juste ajouter le link d'une lib

# ça consiste à créer les dossiers, créer un/des fichier(s) de base, créer le cmake avec les bonnes règles


module DestType
    BIN = 1
    LIB = 2
    HEADER_LIB = 3
end

def main()
    #default values
    arg_type = :name # possible values :name, :incl_boost_lib, :incl_boost_header_lib, :incl_lib
    dest_type = DestType::BIN
    header_dir = false
    test_module = true
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
        elsif a == "--test" then
            test_module = true
        elsif a == "--no_test" then
            test_module = false
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
    puts "yeah"
end

main