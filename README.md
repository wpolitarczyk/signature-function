# Generalized Algebraic Knot Invariants

This project allows calculating knot invariants for linear combinations of iterated torus knots.
It was created as part of the proof for the main lemma from the paper **"On the slice genus of generalized algebraic knots"** (Maria Marchwicka and Wojciech Politarczyk) ([arXiv:2107.11299](https://arxiv.org/abs/2107.11299)).

## Project Structure

The project is organized as follows:

* **`gaknot/`**: Contains the source code (SageMath and Python files). This is the main package directory.
* **`notebooks/`**: Contains Jupyter notebooks for testing and reproducing calculations (e.g., `lemma.ipynb`, `LT-signature.ipynb`).

## Requirements

* **SageMath**: This project relies on the SageMath kernel. Ensure you have a working installation of SageMath (e.g., via Conda or a native install).

## Usage

To use the package, ensure the parent directory of `gaknot` is in your Python path. You can then import modules directly.

### Levine-Tristram Signature (`LT_signature`)

The `LT_signature` module computes the Levine-Tristram signature functions for Generalized Algebraic Knots (GA-knots).
It implements the formulas defined in Litherland's paper *"Signature of iterated torus knots"*.

#### 1. Positive torus knots.

The function `LT_signature_torus_knos` computes the Levine-Tristram signature function of a positive torus knot.

**Example: Computing the signature of T(2,3)**

```python
import gaknot
from gaknot.LT_signature import LT_signature_torus_knot

# Calculate the signature function for Torus Knot T(2,3)
# Note: p and q must be relatively prime
sig = LT_signature_torus_knot(2, 3)

# Print the jump points and values
print(sig)
# Output: 0: 0, 1/6: -1, 5/6: 1, 1: 0.
```

#### 2. Operations and Plotting

The resulting object from both functions is a SignatureFunction, which supports evaluation, algebraic operations, and plotting.

```python
from gaknot.signature import SignaturePloter

# Evaluate the function at a specific point (theta)
val_at_half = sig(1/2)

# Calculate the total signature jump
total_jump = sig.total_sign_jump()

# Plot the step function
SignaturePloter.plot(sig, title="Signature of T(2,3)")
```

#### 3. Iterated Torus Knots

You can also compute the signature for iterated torus knots (cables) using `LT_signature_iterated_torus_knot`. The knot is described as a list of integer pairs $[(p_{1}, q_{1}), (p_{2}, q_{2}), \ldots]$.
For example, `[(2,3), (6,5)]` represents the `(6,5)`-cable of the torus knot `T(2,3)`.

**Example:**

```python
from gaknot.LT_signature import LT_signature_iterated_torus_knot

# Define the iterated knot: (6,5)-cable of T(2,3)
description = [(2, 3), (6, 5)]

# Compute the signature
iterated_sig = LT_signature_iterated_torus_knot(description)

# Plot the result
from gaknot.signature import SignaturePloter
SignaturePloter.plot(iterated_sig, title="Signature of iterated knot [(2,3), (6,5)]")
```

#### 4. Generalized Algebraic Knots

The package can also compute the signature for generalized algebraic knots, defined as a connected sum of positive iterated torus knots or their concordance inverses.

Use the function `LT_signature_generalized_algebraic_knot` with a list of pairs (`sign`, `description`), where:

* `sign`: $1$ for the knot itself, $-1$ for its concordance inverse.

* `description`: A list of integer pairs defining the iterated torus knot (as in section 3).

**Example: Verifying the slice nature of T(2,3)#−T(2,3)**

```python
from gaknot.LT_signature import LT_signature_generalized_algebraic_knot

# Define the connected sum T(2,3) # -T(2,3)
# Structure: [ (sign, [knot_parameters]), ... ]
desc = [
    (1,  [(2,3)]), 
    (-1, [(2,3)])
]

# Compute the signature
gen_sig = LT_signature_generalized_algebraic_knot(desc)

# Check if the signature is zero everywhere (expected for a slice knot)
print(f"Is slice? {gen_sig.is_zero_everywhere()}")
# Output: Is slice? True
``**

** Example: Compute and plot the signature function of $T(2,3;6,5) \# -T(3,4;7,9)$.**

```python
# T(2,3;6,5) # -T(3,4;7,9)
desc = [
    (1, [(2,3), (6,5)]),
    (-1, [(3,4), (7, 9)])
]

sig = LT_signature_generalized_algebraic_knot(desc)

SignaturePloter.plot(sig, title="Generalized algebraic knot T(2,3;6,5) # -T(3,4;7,9).")
```

### Reproducing Proofs

To recreate the exact calculations done for the proof of Lemma 3.2, please refer to the `lemma.ipynb` file located in the `notebooks/` directory.

## Documentation
For a more detailed description of the classes and internal logic, please refer to the docstrings within the gaknot package files.
