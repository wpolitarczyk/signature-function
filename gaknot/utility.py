import importlib
import os
import sys
import math
import logging
import subprocess
import shutil

def mod_one(n):
    r"""calculates the fractional part of the argument

    Argument:
        a number
    Return:
        the fractional part of the argument
    Examples:
        sage: mod_one(9 + 3/4)
        3/4
        sage: mod_one(-9 + 3/4)
        3/4
        sage: mod_one(-3/4)
        1/4
    """
    return n - math.floor(n)

def import_sage(module_name, package=None, path=''):
    r"""Import or reload SageMath modules with preparse if the sage file exist.

    Arguments:
        module_name - name of the module (without file extension!)
        package - use only if module is used as a part of a package
    Return:
        module
    Examples:

        from utility import import_sage
         # equivalent to import module_name as my_prefered_shortcut}
        my_prefered_shortcut = import_sage('module_name')
    """
    
    sage_cmd = shutil.which("sage")
    if not sage_cmd:
        raise EnvironmentError("The 'sage' executable not found in PATH.")

    sage_name = module_name + ".sage"
    python_name = module_name + ".sage.py"
    # Ensure the destination has the .py extension
    module_py_dest = module_name + ".py"

    logging.info("\n\nimport_sage called with arguments:" +
                 "\n\tmodule_name: " + module_name +
                 "\n\tpackage: " + str(package) +
                 "\n\tpath: " + path)

    if package is not None:
        path_from_package_name = package.replace('.', os.sep)
        path = os.path.join(path, path_from_package_name)

    sage_path = os.path.abspath(os.path.join(path, sage_name))
    python_path = os.path.abspath(os.path.join(path, python_name))
    module_py_path = os.path.abspath(os.path.join(path, module_py_dest))

    # logging.info(f'sage_path = {sage_path}')
    # logging.info(f'python_path = {python_path}')
    # logging.info(f'module_py_path = {module_py_path}')

    # logging.info(f'os.path.isfile(sage_path) is {os.path.isfile(sage_path)}')

    if os.path.isfile(sage_path):
        try:
            # shell=True with quotes handles the "My Drive" space
            cmd = f'{sage_cmd} --preparse "{sage_path}"'
            subprocess.run(cmd, shell=True, check=True)
            
            if os.path.exists(python_path):
                if os.path.exists(module_py_path):
                    os.remove(module_py_path)
                shutil.move(python_path, module_py_path)
                
        except subprocess.CalledProcessError as e:
            logging.error(f"Sage preparse failed for {sage_path}: {e}")

    # Standardize the module name for importlib
    full_module_name = f"{package}.{module_name}" if package else module_name

    if full_module_name in sys.modules:
        return importlib.reload(sys.modules[full_module_name])
    return importlib.import_module(full_module_name, package=package)

def parse_sage(module_name):

    sage_cmd = shutil.which("sage")
    if not sage_cmd:
        raise EnvironmentError("The 'sage' executable was not found. Please ensure SageMath is installed and in your PATH.")

    dir = os.path.dirname(__file__)

    sage_name = os.path.abspath(os.path.join(dir, module_name + ".sage"))
    python_name = os.path.abspath(os.path.join(dir, module_name + ".sage.py"))
    module_name = os.path.abspath(os.path.join(dir, module_name + ".py"))

    if os.path.isfile(sage_name):
        try:
            # The key is to ensure sage_path is treated as a single string
            subprocess.run([sage_cmd, '--preparse', sage_name], check=True)
            
            # Check if the .sage.py file was actually created before moving
            if os.path.exists(python_name):
                # Use shutil.move which is safer than shell 'mv'
                shutil.move(python_name, module_name + ".py")
        except subprocess.CalledProcessError as e:
            logging.error(f"Sage preparse failed: {e}")
    else:
        logging.info("sage file not found: " + str(sage_name))

        
