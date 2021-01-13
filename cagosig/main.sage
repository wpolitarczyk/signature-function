#!/usr/bin/env sage -python

# TBD: read about Factory Method, variable in docstring, sage documentation,
# print calc. to output file
# decide about printing option
# make __main__?

import os
import sys

import itertools as it
import re
import numpy as np
import importlib
from .utility import import_sage
from . import signature as sig
from . import cable_signature as cs

package = __name__.split('.')[0]
path = os.path.dirname(__file__)


class Config:
    def __init__(self):

        self.f_results = os.path.join(os.getcwd(), "results.out")

        self.short_3_layers_a = "[[ k[5],  k[3]], " + \
                                "[ -k[1], -k[3]], " + \
                                "[  k[3]], " + \
                                "[ -k[4],  -k[6], -k[3]]]"

        self.short_3_layers_b = "[[k[4],   k[1],  k[7]], " + \
                                "[               -k[7]], " + \
                                "[k[6],  k[7]], " + \
                                "[-k[5], -k[7]]]"
        self.schema_short1 = "[ [k[5],  k[3]], " + \
                         "[ -k[1], -k[3]], " + \
                         "[         k[3]], " + \
                         "[ -k[6], -k[3]]]"

        self.schema_short2 = "[[ k[1],  k[7]], " + \
                         "[        -k[7]], " + \
                         "[  k[6],  k[7]], " + \
                         "[ -k[5], -k[7]]]"

        self.schema_short = "[[ k[5],  k[3]], " + \
                        "[ -k[1], -k[3]], " + \
                        "[         k[3]], " + \
                        "[ -k[6], -k[3]], " + \
                        "[  k[1],  k[7]], " + \
                        "[        -k[7]], " + \
                        "[  k[6],  k[7]], " + \
                        "[ -k[5], -k[7]]]"


        self.two_summands_schema = "[\
                                     [k[0], k[1], k[4]], [-k[1], -k[3]],\
                                     [k[2], k[3]], [-k[0], -k[2], -k[4]]\
                                    ]"
        knot_formula = "[[k[0], k[1], k[2]], [k[3], k[4]],\
                         [-k[0], -k[3], -k[4]], [-k[1], -k[2]]]"

        knot_formula = "[[k[0], k[1], k[2]], [k[3]],\
                         [-k[0], -k[1], -k[3]], [-k[2]]]"



        self.two_small_summands_schema = "[[k[3]], [-k[3]],\
                                          [k[3]], [-k[3]] ]"

        self.four_summands_schema = "[[k[3], k[2], k[0]],\
                                     [-k[2], -k[0]],\
                                     [k[1], k[0]],\
                                     [-k[3], -k[1], -k[0]]]"

        self.four_summands_schema = "[[k[0], k[1], k[3]]," + \
                                   " [-k[1], -k[3]]," + \
                                   " [k[2], k[3]]," + \
                                   " [-k[0], -k[2], -k[3]]]"

        formula_1 = "[[k[0], k[5], k[3]], " + \
                          "[-k[1], -k[3]], " + \
                           "[k[2], k[3]], " + \
                   "[-k[0], -k[2], -k[3]]]"
        formula_2 = "[[k[4], k[1], k[7]], " + \
                          "[-k[5], -k[7]], " + \
                           "[k[6], k[7]], " + \
                   "[-k[4], -k[6], -k[7]]]"

        formula_1 = "[[k[0], k[5], k[3]], " + \
                          "[-k[5], -k[3]], " + \
                           "[k[2], k[3]], " + \
                    "[-k[4], -k[2], -k[3]]]"
        formula_2 = "[[k[4], k[1], k[7]], " + \
                          "[-k[1], -k[7]], " + \
                           "[k[6], k[7]], " + \
                    "[-k[0], -k[6], -k[7]]]"






def main(arg=None):
    try:
        limit = int(arg[1])
    except (IndexError, TypeError):
        limit = None
    conf = Config()
    cable_loop_with_details(conf)

def print_sigma_for_cable(verbose=True, conf=None):

    conf = conf or Config()
    schema_short1 = conf.schema_short1
    schema_short2 = conf.schema_short2
    schema_short = conf.schema_short
    schema_four = conf.four_summands_schema

    cable_template = cs.CableTemplate(knot_formula=schema_short)
    cable_template.fill_q_vector()
    q_v = cable_template.q_vector
    print(q_v)
    print(cable_template.cable.knot_description)
    cable1 = cs.CableTemplate(knot_formula=schema_short1,
                              verbose=verbose,
                              q_vector=q_v
                             ).cable
    cable2 = cs.CableTemplate(knot_formula=schema_short2,
                              verbose=verbose,
                              q_vector=q_v
                             ).cable
    cable = cs.CableTemplate(knot_formula=schema_short1,
                              verbose=verbose,
                              q_vector=q_v
                             ).cable

    cable.plot_sigma_for_summands()
    # cable1.plot_sigma_for_summands()
    # cable2.plot_sigma_for_summands()


def cable_loop_with_details(verbose=True, conf=None):
    conf = conf or Config()
    # verbose = False
    schema_short1 = conf.schema_short1
    schema_short2 = conf.schema_short2
    schema_short = conf.schema_short
    cable_template = cs.CableTemplate(knot_formula=schema_short)

    list_of_q_vectors = []
    # for el in [2, 3, 5, 7, 11, 13]:
    for el in [2]:
        cable_template.fill_q_vector(lowest_number=el)
        q_v = cable_template.q_vector
        print(q_v)
        print(cable_template.cable.knot_description)
        cable1 = cs.CableTemplate(knot_formula=schema_short1,
                                  verbose=verbose,
                                  q_vector=q_v
                                 ).cable
        cable2 = cs.CableTemplate(knot_formula=schema_short2,
                                  verbose=verbose,
                                  q_vector=q_v
                                 ).cable
    #     print("\n")
    #     print(cable1.knot_description)
        is_1 = cable1.is_function_big_for_all_metabolizers(invariant=cs.SIGMA)
        is_2 = cable2.is_function_big_for_all_metabolizers(invariant=cs.SIGMA)
        if is_1 and is_2:
            print("sigma is big for all metabolizers")
        else:
            print("sigma is not big for all metabolizers")
        print("\n" * 3)

def few_cable_without_calc(verbose=False, conf=None):

    conf = conf or Config()
    schema_short1 = conf.schema_short1
    schema_short2 = conf.schema_short2
    schema_short = conf.schema_short

    cable_template = cs.CableTemplate(knot_formula=schema_short)

    list_of_q_vectors = []
    for el in [2, 3, 5, 7, 11, 13]:
        cable_template.fill_q_vector(lowest_number=el)
        q_v = cable_template.q_vector
        print(q_v)
        print(cable_template.cable.knot_description)
        cable1 = cs.CableTemplate(knot_formula=schema_short1,
                              verbose=verbose,
                              q_vector=q_v
                             ).cable
        cable2 = cs.CableTemplate(knot_formula=schema_short2,
                                  verbose=verbose,
                                  q_vector=q_v
                                 ).cable
        is_1 = cable1.is_function_big_for_all_metabolizers(invariant=sigma)
        is_2 = cable2.is_function_big_for_all_metabolizers(invariant=sigma)
        if is_1 and is_2:
            print("sigma is big for all metabolizers")
        else:
            print("sigma is not big for all metabolizers")
        print("\n" * 3)

def smallest_cable(verbose=True, conf=None):

    conf = conf or Config()
    schema_short1 = conf.schema_short1
    schema_short2 = conf.schema_short2
    schema_short = conf.schema_short


    cable_template = cs.CableTemplate(knot_formula=schema_short)
    q_v = cable_template.q_vector
    print(q_v)
    cable1 = cs.CableTemplate(knot_formula=schema_short1,
                              verbose=verbose,
                              q_vector=q_v).cable
    cable2 = cs.CableTemplate(knot_formula=schema_short2,
                              verbose=verbose,
                              q_vector=q_v).cable
    cable1.is_function_big_for_all_metabolizers(invariant=sigma)
    cable2.is_function_big_for_all_metabolizers(invariant=sigma)

def plot_many_untwisted_signature_functions(range_tuple=(1, 10)):
    P = Primes()
    for i in range(*range_tuple):
        q = P.unrank(i)
        a = cs.CableSummand.get_untwisted_signature_function(q=q)
        a.plot()


if __name__ == '__main__':
    global config
    config = Config()
    if '__file__' in globals():
        # skiped in interactive mode as __file__ is not defined
        main(sys.argv)
    else:
        pass
        # main()

#
#
# formula_long = "[[k[0], k[5], k[3]], " + \
#                   "[-k[5], -k[3]], " + \
#                    "[k[2], k[3]], " + \
#             "[-k[4], -k[2], -k[3]]" + \
#             "[k[4], k[1], k[7]], " + \
#                   "[-k[1], -k[7]], " + \
#                    "[k[6], k[7]], " + \
#             "[-k[0], -k[6], -k[7]]]"
#
#
# formula_1 = "[[k[0], k[5], k[3]], " + \
#                   "[-k[1], -k[3]], " + \
#                          "[ k[3]], " + \
#             "[-k[4], -k[6], -k[3]]]"
#
# formula_2 = "[[k[4], k[1], k[7]], " + \
#                        "[ -k[7]], " + \
#                    "[k[6], k[7]], " + \
#             "[-k[0], -k[5], -k[7]]]"
#
#
