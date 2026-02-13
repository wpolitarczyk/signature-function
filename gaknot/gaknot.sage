from sage.all import Integer, gcd

class GeneralizedAlgebraicKnot:
    """
    Represents a generalized algebraic knot, formed by taking connected sums 
    of iterated positive cables of positive torus knots and their concordance inverses.
    """

    def __init__(self, desc):
        """
        Initializes the knot with a validated description.
        """
        # Validate the description before storing it
        self.__class__.verify_description(desc)
        self._desc = desc


    @staticmethod
    def verify_description(desc):
        """
        Verifies if the provided description is a valid generalized algebraic knot.
        Raises TypeError or ValueError with detailed context if the description is invalid.
        Returns True if the description is perfectly valid.
        """
        if not isinstance(desc, (list, tuple)):
            raise TypeError(f"The description must be a list or tuple. Got {type(desc)}.")

        for i, element in enumerate(desc):
            # 1. Check the top-level pair (sign, knot_description)
            if not isinstance(element, (list, tuple)) or len(element) != 2:
                raise ValueError(f"Element at index {i} must be a pair (sign, knot_description).")
            
            sign, knot_desc = element

            # 2. Check the sign
            if sign not in (1, -1):
                raise ValueError(f"Sign at index {i} must be 1 or -1. Got {sign}.")

            # 3. Check the iterated torus knot description container
            if not isinstance(knot_desc, (list, tuple)):
                raise TypeError(f"Knot description at index {i} must be a list or tuple.")

            # 4. Check each cabling step (p, q)
            for j, cable_pair in enumerate(knot_desc):
                if not isinstance(cable_pair, (list, tuple)) or len(cable_pair) != 2:
                    raise ValueError(f"Cable parameter at index {i}, sub-index {j} must be a pair (p, q).")
                
                p, q = cable_pair
                
                # Type check for integers
                if not isinstance(p, (int, Integer)) or not isinstance(q, (int, Integer)):
                    raise TypeError(f"Parameters p and q must be integers. Got {type(p)}, {type(q)} at index {i}, {j}.")
                    
                # Positivity check
                if p <= 1 or q <= 1:
                    raise ValueError(f"Parameters p and q must be > 1. Got ({p}, {q}) at index {i}, {j}.")

                # Coprimality check
                if gcd(p, q) != 1:
                    raise ValueError(f"Parameters p and q must be relatively prime. Got gcd({p}, {q}) != 1 at index {i}, {j}.")
        
        return True


    @property
    def description(self):
        """Read-only access to the knot description."""
        return self._desc


    def __add__(self, other):
        """
        Connected sum of two generalized algebraic knots.
        """
        if not isinstance(other, GeneralizedAlgebraicKnot):
            raise TypeError("Can only add another GeneralizedAlgebraicKnot.")
        
        new_knot_desc = self.description + other.description
        return GeneralizedAlgebraicKnot(new_knot_desc)

    def __neg__(self):
        """
        Concordance inverse of the knot (flips the sign of every component).
        """
        new_knot_desc = [(-sign, knot_desc) for sign, knot_desc in self.description]
        return GeneralizedAlgebraicKnot(new_knot_desc)


    @staticmethod
    def _it_torus_knot_desc_to_txt(desc):
        """
        Helper method to format the iterated torus knot sequence.
        Example: [(2,3), (6,5)] -> 'T(2,3; 6,5)'
        """
        return 'T(' + '; '.join([f"{p},{q}" for p, q in desc]) + ')'

    def __str__(self):
        """
        Returns the human-readable string representation of the generalized algebraic knot.
        Example: 'T(2,3; 2,5; 3,4) # -T(5,2; 3,7)'
        """
        components = []
        for sign, knot_desc in self.description:
            # Map the sign to a minus string or an empty string
            prefix = "-" if sign == -1 else ""
            knot_str = self._it_torus_knot_desc_to_txt(knot_desc)
            components.append(f"{prefix}{knot_str}")
        
        return ' # '.join(components)

    def __repr__(self):
        """
        Returns the developer representation, which shows the exact data structure 
        needed to recreate the object.
        """
        return f"GeneralizedAlgebraicKnot({self.description})"

    
