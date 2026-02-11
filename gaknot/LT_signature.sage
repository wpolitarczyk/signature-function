#!/usr/bin/env sage -python

import math
import os
from collections import Counter

from .utility import mod_one

from sage.all import Integer, gcd

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


def reparametrize(sig_func, p):
    """
    Helper function to compute sigma(p*theta) given sigma(theta).
    This effectively 'compresses' the signature function, repeating it p times
    scaled down by 1/p.
    """
    # Access the jumps dictionary (Counter) from the SignatureFunction object
    old_counter = sig_func.jumps_counter
    new_counter = Counter()

    # If sigma(theta) has a jump at x, then sigma(p*theta) has jumps
    # whenever p*theta = x + k (integer), so theta = (x + k) / p
    for x, jump_val in old_counter.items():
        for k in range(p):
            new_x = (x + k) / p
            new_counter[new_x] += jump_val
            
    return sg.SignatureFunction(counter=new_counter)


def LT_signature_iterated_torus_knot(desc):
    """
    Computes the Levine-Tristram signature for an iterated torus knot.
    
    Arguments:
        desc: A list of pairs (p, q) describing the cabling process.
              Example: [(2,3), (6,5)] is the (6,5)-cable of T(2,3).
    """
    # --- Validation Section ---
    if not isinstance(desc, (list, tuple)):
        raise TypeError('The variable desc should be a list or tuple.')

    for i, el in enumerate(desc):
        # Allow lists or tuples
        if not isinstance(el, (list, tuple)) or len(el) != 2:
            raise ValueError(f'Element at index {i} must be a pair (tuple or list of size 2).')
        
        p, q = el
        
        # Check for non-integers (handling both Python int and Sage Integer)
        if not isinstance(p, (int, Integer)) or not isinstance(q, (int, Integer)):
            raise TypeError(f'Parameters at index {i} must be integers. Got {type(p)}, {type(q)}.')
            
        if p <= 1 or q <= 1:
            raise ValueError(f'Parameters at index {i} must be integers > 1. Got ({p}, {q}).')

        # Mathematical consistency check
        if gcd(p, q) != 1:
            raise ValueError(f'Parameters at index {i} ({p}, {q}) must be relatively prime.')

    # --- Calculation Section ---
    
    # Start with an empty signature (effectively 0 everywhere)
    # or None, handling the first iteration distinctly
    current_sig = None

    for (p, q) in desc:
        # 1. Calculate the signature of the torus knot T(p,q)
        torus_sig = LT_signature_torus_knot(p, q)
        
        if current_sig is None:
            # Base case: The first knot in the sequence is just T(p,q)
            current_sig = torus_sig
        else:
            # Recursive step: sigma_new(theta) = sigma_T(p,q)(theta) + sigma_old(p*theta)
            # Note: p is the number of longitudinal strands (the first entry in the pair)
            reparametrized_old = reparametrize(current_sig, p)
            current_sig = torus_sig + reparametrized_old
            
    return current_sig
