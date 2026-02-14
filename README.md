# Generalized Algebraic Knot Invariants

This project allows calculating signature invariants for generalized algebraic knots (`GA-knots`).
Generalized algebraic knots are knots constructed as connected sums of positive iterated torus knots and their concordance inverses.
It was created as part of the proof for the main lemma from the paper **"On the slice genus of generalized algebraic knots"** (Maria Marchwicka and Wojciech Politarczyk) ([arXiv:2107.11299](https://arxiv.org/abs/2107.11299)).

## Project Structure

The project is organized as follows:

* **`gaknot/`**: Contains the source code (SageMath and Python files). This is the main package directory.
* **`notebooks/`**: Contains Jupyter notebooks for testing and reproducing calculations:
  * `lemma.ipynb`: Core calculations for the proof of Lemma 3.2.
  * `LT-signature.ipynb`: Tests for the core Levine-Tristram signature module.
  * `gaknot-test.ipynb`: Interactive tests and usage examples for the `GeneralizedAlgebraicKnot` class.

## Requirements

* **SageMath**: This project relies on the SageMath kernel. Ensure you have a working installation of SageMath (e.g., via Conda or a native install).

## Installation and Usage
You can use the `gaknot` module in your own projects or `SageMath` installation using one of the following methods:

**Option 1: Environment Variable (Recommended)**

To make the module available globally in your `SageMath` installation without modifying your scripts, add the directory containing the `gaknot` folder to the `SAGE_PATH` environment variable.

On Linux/macOS:
Add the following line to your shell configuration file (e.g., .bashrc, .zshrc):

```bash
export SAGE_PATH="/absolute/path/to/directory_containing_gaknot:$SAGE_PATH"
```

Restart your terminal. You can now import the module directly in any Sage session:

```python
sage: from gaknot import GeneralizedAlgebraicKnot
```

**Option 2: Manual Path Addition**

If you prefer not to modify environment variables, you can manually add the path within your Python script or Jupyter notebook before importing the module:

```python
import sys
# Append the directory containing the 'gaknot' package
sys.path.append("/path/to/directory_containing_gaknot")

from gaknot import GeneralizedAlgebraicKnot
```
## Usage

To use the package, ensure the parent directory of `gaknot` is in your Python path. You can then import modules directly.

### 1. Working with Generalized Algebraic Knots

The easiest way to work with the package is using the `GeneralizedAlgebraicKnot` class. A generalized algebraic knot is defined as a connected sum of positive iterated torus knots or their concordance inverses.

**Defining and operating on knots:**
The knot description is a list of pairs `(sign, knot_description)`, where:

* `sign`: `1` for the knot itself, `-1` for its concordance inverse.
* `knot_description`: A list of integer pairs defining the cabling sequence (e.g., `[(2,3), (6,5)]` is the $(6,5)$-cable of $T(2,3)$ denoted by $T(2,3;6,5)$).

```python
import gaknot
from gaknot.gaknot import GeneralizedAlgebraicKnot

# Define T(2,3) and T(3,4)
knot1 = GeneralizedAlgebraicKnot([(1, [(2, 3)])])
knot2 = GeneralizedAlgebraicKnot([(1, [(3, 4)])])

# Operations: Connected sum (+) and Concordance inverse (-)
sum_knot = knot1 + knot2
inverse_knot = -knot1

# Human-readable string representation
print(sum_knot)
# Output: T(2,3) # T(3,4)
```

**Computing the Signature:**
You can easily extract the Levine-Tristram signature directly from the knot object.

```python
# Create the algebraically slice knot T(2,3) # -T(2,3)
slice_knot = knot1 + (-knot1)

# Compute the signature function
sig_func = slice_knot.signature()

# Verify that the signature function is zero
print(sig_func.is_zero_everywhere())
# Output: True
```

We can also test it on Litherland's example.

```python
# Define the knot T(2,3;5,2) # T(3,2) # T(5,3) # -T(6,5)
desc = [
    (1, [(2,3), (5,2)]),
    (1, [(3,2)]),
    (1, [(5,3)]),
    (-1, [(6,5)])
]

alg_slice_knot = GeneralizedAlgebraicKnot(desc)

# compute the LT_signature
sig_func = alg_slice_knot.signature()

# Verify if it evaluates to 0 (since it's an algebraically slice knot)
print(f"Is the signature zero everywhere? {sig_func.is_zero_everywhere()}")

# Plot the signature function
from gaknot.signature import SignaturePloter
SignaturePloter.plot(sig_func, title=f"Signature of {alg_slice_knot}")
```

### 2. The `LT_signature` module

If you need to bypass the class wrapper, you can compute signatures directly using the functional modules.

**Torus Knots:**

```python
from gaknot.LT_signature import LT_signature_torus_knot

# Calculate the signature function for Torus Knot T(2,3)
# Note: parameters must be relatively prime
sig = LT_signature_torus_knot(2, 3)
```

**Iterated Torus Knots:**

```python
from gaknot.LT_signature import LT_signature_iterated_torus_knot

# (6,5)-cable of T(2,3)
iterated_sig = LT_signature_iterated_torus_knot([(2, 3), (6, 5)])
```

**Generalized Algebraic Knots**

```python
from gaknot.LT_signature import LT_signature_generalized_algebraic_knot
desc = [
    (1, [(2,3), (5,2)]),
    (1, [(3,2)]),
    (1, [(5,3)]),
    (-1, [(6,5)])
]

gaknot_sig = LT_signature_generalized_algebraic_knot(desc)
```

### 3. Operations and Plotting

The resulting object from any signature computation is a `SignatureFunction`, which supports evaluation, algebraic operations, and visualization.

```python
from gaknot.signature import SignaturePloter

# Evaluate the function at a specific point (theta)
val_at_half = sig(1/2)

# Calculate the total signature jump
total_jump = sig.total_sign_jump()

# Plot the step function
SignaturePloter.plot(sig, title="Signature of T(2,3)")
```

## Documentation
For a more detailed description of the classes, validation rules, and internal logic, please refer to the docstrings within the gaknot package files or explore the notebooks/ directory.
