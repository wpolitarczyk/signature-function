import importlib
import os
import sys
import re



def import_sage(module_name, package=None, path=None):
    """
    Import or reload SageMath modules with preparse if the sage file exist.
    """

    sage_name = module_name + ".sage"
    python_name = module_name + ".sage.py"
    if package is not None:
        path_from_package_name = re.sub(r'\.', r'\\', package)
        file_path = os.path.join('', path, path_from_package_name)
    else:
        file_path = os.path.join('', path)

    sage_path = os.path.join(file_path, sage_name)
    python_path = os.path.join(file_path, python_name)
    module_path = os.path.join(file_path, module_name)

    if os.path.isfile(sage_path):
        os.system('sage --preparse {}'.format(sage_path));
        os.system('mv {} {}.py'.format(python_path, module_path))

    if package is not None:
        module_name = package + "." + module_name

    if module_name in sys.modules:
        return importlib.reload(sys.modules[module_name])
    return importlib.import_module(module_name, package=package)

def parse_sage(module_name):

    dir = os.path.dirname(__file__)

    sage_name = os.path.join(dir, module_name + ".sage")
    python_name = os.path.join(dir, module_name + ".sage.py")
    module_name = os.path.join(dir, module_name + ".py")

    os.system('sage --preparse {}'.format(sage_name))
    os.system('mv {} {}'.format(python_name, module_name))
