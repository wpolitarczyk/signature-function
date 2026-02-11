#!/usr/bin/env sage -python

import math
import os
from . import signature
from .utility import mod_one

def LT_signature_torus_knot(p, q):
    """
    Computes the Levine-Tristram signature of torus knot T(p,q) 
    based on Litherland (1979).
    """

    if math.gcd(p, q) != 1:
        raise ValueError('Parameters p and q have to be relatively prime.')

    def find_ab(p, q, x):
        # Combined helper to find a, b such that p*q*x = a*p + i*q
        # We need (p*x*q - i*p)/q to be an integer
        for i in range(1, q):
            val = (p * x * q - i * p)
            if val % q == 0:
                return i, val // q
        return None

    def h(p, q, x):
        res = find_ab(p, q, x)
        if not res: return 1 # Default if no jump condition met
        a_val, b_val = res
        exponent = (math.floor(a_val / q) + 
                    math.floor(b_val / p) + 
                    math.floor(a_val / q + b_val / p))
        return (-1) ** exponent

    # Jump points are k/(pq) such that p*x and q*x are NOT integers
    potential_roots = [i / (p * q) for i in range(1, p * q)]
    
    jumps = [x for x in potential_roots if mod_one(p * x) != 0 and mod_one (q * x) != 0]

    # Map jumps to their h values
    values = [[j, h(p, q, j)] for j in jumps]

    # Correct reference to the imported signature module
    return signature.SignatureFunction(values=values)
