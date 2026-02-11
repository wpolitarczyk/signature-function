#!/usr/bin/env sage -python

import math
import os
from .utility import mod_one

# Internal import logic to handle package context
if __name__ == '__main__':
    from utility import import_sage
    package = None
    path = ''
else:
    from .utility import import_sage
    package = __name__.rsplit('.', 1)[0]
    # We use the path of the current file to find siblings
    path = os.path.dirname(os.path.abspath(__file__))

# Import signature module and assign to 'sg'.
sg = import_sage('signature', package=package, path=path)

def LT_signature_torus_knot(p, q):
    """
    Computes the Levine-Tristram signature function of a torus knot T(p,q).
    The method follows formula (1) and (2) from Litherland's paper.
    """

    if math.gcd(p, q) != 1:
        raise ValueError('Parameteres p and q must be relatively prime.')

    def a(p, q, x):
        # Find i in range(1, q) such that (p*x*q - i*p)/q is an integer
        for i in range(1, q):
            if (p * x * q - i * p) % q == 0:
                return i
        return 0
    
    def b(p, q, x):
        # Find i in range(1, q) to compute the 'b' value for the jump formula
        for i in range(1, q):
            if (p * x * q - i * p) % q == 0:
                return (p * x * q - i * p) // q
        return 0

    def h(p, q, x):
        # Helper function h_{p,q} based on Litherland's exponent formula
        a_val = a(p, q, x)
        b_val = b(p, q, x)
        exponent = (math.floor(a_val / q) + 
                    math.floor(b_val / p) + 
                    math.floor(a_val / q + b_val / p))
        return (-1) ** exponent

    # Jump points occur at i/(pq) where p*x and q*x are not integers
    roots = [i / (p * q) for i in range(1, p * q)]
    jumps = [x for x in roots if mod_one(p * x) != 0 and mod_one(q * x) != 0]

    # Map jumps to their h values to build the signature data
    values = [[j, h(p, q, j)] for j in jumps]

    # Construct the SignatureFunction using the correctly assigned 'sg' module
    return sg.SignatureFunction(values=values)
