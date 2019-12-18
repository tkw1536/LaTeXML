#############################################################################################
# This file is an example of a specification file as used by the latexml_magic_tests function
#############################################################################################

# The basic syntax is of the form "key=value". Value may be empty, Key may not be. 
# Spaces at the beginning and end of keys and values are ignored. 
# Lines starting with '#' or ';' and blank lines are ignored. 
# Lines that do not contain a '=', and do not start with '#' or ';' and are not blank are considered an error. 
# Keys may be repeated and are executed in order. 
# The syntax of the file is simiular to '.ini' files, with the exception that keys can be repeated and sections are not supported. 

# for example, the following line produces a key 'key' and sets it to 'value'
key=value

# so does the following one:
   key=value    

# so does this one:
key = value

######################################
# Magic inclusions #
######################################

# 'include-spec' loads a set of different files (in alphabetical order) into this file. 
# Includes work *as if* the user had directly typed the lines of the included files into this one.
# Beware that nested includes are supported, but may result in problems if relative paths are used. 
# A non-existing file is an error, a glob matching 0 files is not. 
include-spec = file-or-glob.spec

# 'disable' allows bailing out of a spec file early and declaring it as disabled. 
# When a file is disabled, it will not be run and not be counted as matching a pattern. 

# Never disable this file. Default. 
disable = no
# Do not run this file, unless it is run inside an included context. 
disable = unless-included
# Always disable this file.
disable = yes

# 'run' runs the tests specified in a different file.
# Each run file will be exposed as a single subtest.
# This may be either a concrete filename or a bash-like glob.
# A non-existing file is an error, a glob matching 0 files is not. 
run = file-or-glob.spec

# 'run-profile' specifies a 'profile' to run all other tests run using a '.spec' file.
# A profile acts like an include at the beginning of each included file. 
# To disable profiles, set it to an empty value. 
run-profile = some-profile.spec



# 'recurse' behaves like 'run' expect that it expects that the argument resolves to a set of folders. 
# Each folder is then run as a single subtest. 
recurse = folder-or-spec



# 'source' instructs the tests to pass each file as an option to 'latexmlc' with all options provided
# anywhere in the current file. 
# A non-existing file is an error, a glob matching 0 files is not. 
source = file-or-glob.xml


# 'expect-output-file' tells LaTeXML to expect the ouput of a given file inside files corresponding to the input but with the given extension. 
# If an source filename has no extension, append this extension. 
# An output file that does not exist is an error. 
expect-output = xml

# 'expect-status' tells LaTeXML to expect the status of a given file inside files corresponding to the input but with the given extension. 
# For legacy reasons, when 'expect-status' is blank (default) expects that latexml exists succesfully and places no further restrictions on the output
# An output file that does not exist is an error. 
expect-status = 

# make_test_plan

# Pass 1: Read syntax, throw errors for syntax errors
# Pass 2: Process includes + disables

# Pass 3: Find recurses
# Pass 4: Find runs

# Stage 5: Collection Options & Inputs