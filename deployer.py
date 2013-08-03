#!/usr/bin/python

import os
from optparse import OptionParser

PROJECT_FOLDER = "/Users/dst/dev/projects/"


def create_dir(directory):
    if not os.path.lexists(directory):
        os.makedirs(directory)
        print("Created dir %s" % directory)
    else:
        print("Dir %s already exists" % directory)


def create_symlink(source_dir, dest_dir, folder):
    origin = os.path.join(source_dir, folder)
    new_dir = os.path.join(dest_dir, folder)
    if not os.path.lexists(new_dir):
        os.symlink(origin,new_dir)
        print("Created sym link %s" % new_dir)
    else:
        print("Dir %s already exists" % new_dir)


def main():
    parser = OptionParser()
    parser.add_option("-p", "--project", dest="projectname",
                      help="target project to be installed")

    (options, args) = parser.parse_args()

    pythonenv = "/usr/local/pythonenv"
    documents_dir = "/usr/local/www/documents"
    wsgi_dir = "/usr/local/www/wsgi-scripts/"

    create_dir(documents_dir)
    create_dir(wsgi_dir)
    create_dir(pythonenv)

    create_symlink(PROJECT_FOLDER, documents_dir, options.projectname)

    # create_symlink
main()
