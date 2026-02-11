#!/usr/bin/env python3

r"""calculations of signature function and sigma invariant of generalized algebraic knots (GA-knots)


The package was used to prove Lemma 3.2 from a paper
'On the slice genus of generalized algebraic knots' Maria Marchwicka and Wojciech Politarczyk).
It contains the following submodules.
    1) main.sage - with function prove_lemma
    2) signature.sage - contains SignatureFunction class;
       it encodes twisted and untwisted signature functions
       of knots and allows to perform algebraic operations on them.
    3) cable_signature.sage - contains the following classes:
        a) CableSummand - it represents a single cable knot,
        b) CableSum - it represents a cable sum, i. e. linear combination of single cable knots;
           since the signature function and sigma invariant are additive under connected sum,
           the class use calculations from CableSummand objects,
        c) CableTemplate - it represents a scheme for a cable sums.
    4) LT-signature.sage - functions for computing LT-signature functions for iterated torus knots.
"""


from .utility import import_sage
import os

package = __name__.split('.')[0]
dirname = os.path.dirname
path = dirname(dirname(__file__))
import_sage('signature', package=package, path=path)
import_sage('cable_signature', package=package, path=path)
import_sage('main', package=package, path=path)
import_sage('LT_signature', package=package, path=path)

from .main import prove_lemma


# EXAMPLES::
#
# sage: eval_cable_for_null_signature([[1, 3], [2], [-1, -2], [-3]])
#
# T(2, 3; 2, 7) # T(2, 5) # -T(2, 3; 2, 5) # -T(2, 7)
# Zero cases: 1
# All cases: 1225
# Zero theta combinations:
# (0, 0, 0, 0)
#
# sage:
#
# The numbers given to the function eval_cable_for_null_signature are k-values
# for each component/cable in a direct sum.
#
# To calculate signature function for a knot and a theta value, use function
# get_signature_as_function_of_theta (see help/docstring for details).
#
# About notation:
# Cables that we work with follow a schema:
#     T(2, q_1; 2, q_2; 2, q_4) # -T(2, q_2; 2, q_4) #
#             # T(2, q_3; 2, q_4) # -T(2, q_1; 2, q_3; 2, q_4)
# In knot_formula each k[i] is related with some q_i value, where
# q_i = 2*k[i] + 1.
# So we can work in the following steps:
# 1) choose a schema/formula by changing the value of knot_formula
# 2) set each q_i all or choose range in which q_i should varry
# 3) choose vector v / theta vector.
#
