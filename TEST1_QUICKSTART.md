# Test 1 Quick-Start Guide - Grain Basis Lensing

**Goal**: Test if adding grain basis improves weak lensing fits  
**Timeline**: Start this week, results in 5 weeks  
**Cost**: $0 (all public data)

---

## Day 1: Setup (Today!)

### 1. Register for Data Access

**KiDS (Easiest to start)**:
```bash
# Go to: http://kids.strw.leidenuniv.nl/
# Click "Data Release 4"
# Register (free, instant approval)
# Download shear catalog
```

**DES (Larger dataset)**:
```bash
# Go to: https://des.ncsa.illinois.edu/
# Create DESDM account (free, ~1 day approval)
# Access Y3 shear catalogs
```

### 2. Install Dependencies

```bash
# Create conda environment
conda create -n ivi_test python=3.10
conda activate ivi_test

# Install packages
pip install numpy scipy matplotlib astropy
pip install healpy  # For spherical geometry
pip install treecorr  # For correlation functions (optional)

# Optional: GPU acceleration
pip install cupy  # If you have NVIDIA GPU
```

### 3. Download First Dataset

```bash
# KiDS DR4 shear catalog (~2GB)
wget http://kids.strw.leidenuniv.nl/DR4/KiDS_DR4.1_ugriZYJHKs_shear_noSG_noWeiCut.cat

# Or use Python:
python
>>> from astropy.io import fits
>>> from urllib.request import urlretrieve
>>> url = "http://kids.strw.leidenuniv.nl/DR4/KiDS_DR4.1_ugriZYJHKs_shear_noSG_noWeiCut.cat"
>>> urlretrieve(url, "KiDS_DR4_shear.cat")
```

---

## Day 2-3: Load and Explore Data

### Load Shear Catalog

```python
import numpy as np
from astropy.io import fits
from astropy.table import Table

# Load KiDS shear catalog
data = Table.read('KiDS_DR4_shear.cat', format='fits')

# Extract key columns
ra = data['RAJ2000']  # Right ascension (degrees)
dec = data['DECJ2000']  # Declination (degrees)
e1 = data['e1']  # Shear component 1
e2 = data['e2']  # Shear component 2
weight = data['weight']  # Measurement weight
z_phot = data['Z_B']  # Photometric redshift

print(f"Loaded {len(ra)} galaxies")
print(f"RA range: {ra.min():.2f} to {ra.max():.2f}")
print(f"Dec range: {dec.min():.2f} to {dec.max():.2f}")
print(f"Redshift range: {z_phot.min():.2f} to {z_phot.max():.2f}")
```

### Visualize Shear Field

```python
import matplotlib.pyplot as plt

# Plot shear vectors (subsample for clarity)
subsample = np.random.choice(len(ra), 10000, replace=False)

plt.figure(figsize=(12, 8))
plt.quiver(ra[subsample], dec[subsample], 
           e1[subsample], e2[subsample],
           alpha=0.3, scale=50)
plt.xlabel('RA (deg)')
plt.ylabel('Dec (deg)')
plt.title('KiDS DR4 Shear Field (10k galaxies)')
plt.savefig('shear_field.png', dpi=150)
plt.show()
```

### Basic Statistics

```python
# Shear statistics
print(f"Mean e1: {np.mean(e1):.6f} ± {np.std(e1):.6f}")
print(f"Mean e2: {np.mean(e2):.6f} ± {np.std(e2):.6f}")
print(f"RMS shear: {np.sqrt(np.mean(e1**2 + e2**2)):.6f}")

# Check for systematics
plt.figure(figsize=(12, 4))

plt.subplot(131)
plt.hist(e1, bins=50, alpha=0.7)
plt.xlabel('e1')
plt.ylabel('Count')
plt.title('e1 Distribution')

plt.subplot(132)
plt.hist(e2, bins=50, alpha=0.7)
plt.xlabel('e2')
plt.ylabel('Count')
plt.title('e2 Distribution')

plt.subplot(133)
plt.hist(z_phot, bins=50, alpha=0.7)
plt.xlabel('Redshift')
plt.ylabel('Count')
plt.title('Redshift Distribution')

plt.tight_layout()
plt.savefig('data_quality.png', dpi=150)
plt.show()
```

---

## Day 4-7: Implement Standard Fit

### Kaiser-Squires Mass Reconstruction

```python
from scipy.fft import fft2, ifft2, fftfreq

def kaiser_squires(e1, e2, ra, dec, smoothing=1.0):
    """
    Kaiser-Squires mass reconstruction from shear.
    
    Parameters:
    - e1, e2: shear components
    - ra, dec: positions (degrees)
    - smoothing: Gaussian smoothing scale (arcmin)
    
    Returns:
    - kappa: convergence map
    - ra_grid, dec_grid: grid coordinates
    """
    # Create grid
    ra_min, ra_max = ra.min(), ra.max()
    dec_min, dec_max = dec.min(), dec.max()
    
    n_pixels = 256  # Grid resolution
    ra_grid = np.linspace(ra_min, ra_max, n_pixels)
    dec_grid = np.linspace(dec_min, dec_max, n_pixels)
    
    # Bin shear onto grid
    e1_grid = np.zeros((n_pixels, n_pixels))
    e2_grid = np.zeros((n_pixels, n_pixels))
    counts = np.zeros((n_pixels, n_pixels))
    
    for i in range(len(ra)):
        # Find grid cell
        i_ra = int((ra[i] - ra_min) / (ra_max - ra_min) * (n_pixels - 1))
        i_dec = int((dec[i] - dec_min) / (dec_max - dec_min) * (n_pixels - 1))
        
        if 0 <= i_ra < n_pixels and 0 <= i_dec < n_pixels:
            e1_grid[i_dec, i_ra] += e1[i] * weight[i]
            e2_grid[i_dec, i_ra] += e2[i] * weight[i]
            counts[i_dec, i_ra] += weight[i]
    
    # Normalize
    mask = counts > 0
    e1_grid[mask] /= counts[mask]
    e2_grid[mask] /= counts[mask]
    
    # Fourier transform
    e1_k = fft2(e1_grid)
    e2_k = fft2(e2_grid)
    
    # Wave vectors
    kx = fftfreq(n_pixels) * 2 * np.pi
    ky = fftfreq(n_pixels) * 2 * np.pi
    kx_grid, ky_grid = np.meshgrid(kx, ky)
    k2 = kx_grid**2 + ky_grid**2
    k2[0, 0] = 1  # Avoid division by zero
    
    # Kaiser-Squires inversion
    kappa_k = (kx_grid**2 - ky_grid**2) / k2 * e1_k + \
              2 * kx_grid * ky_grid / k2 * e2_k
    
    # Smoothing
    smooth_k = np.exp(-k2 * smoothing**2 / 2)
    kappa_k *= smooth_k
    
    # Inverse transform
    kappa = ifft2(kappa_k).real
    
    return kappa, ra_grid, dec_grid

# Run reconstruction
kappa, ra_grid, dec_grid = kaiser_squires(e1, e2, ra, dec)

# Visualize
plt.figure(figsize=(10, 8))
plt.imshow(kappa, extent=[ra_grid.min(), ra_grid.max(), 
                          dec_grid.min(), dec_grid.max()],
           origin='lower', cmap='RdBu_r', vmin=-0.1, vmax=0.1)
plt.colorbar(label='Convergence κ')
plt.xlabel('RA (deg)')
plt.ylabel('Dec (deg)')
plt.title('KiDS DR4 Mass Map (Kaiser-Squires)')
plt.savefig('mass_map_standard.png', dpi=150)
plt.show()
```

### Compute Residuals

```python
def convergence_to_shear(kappa, ra_grid, dec_grid):
    """
    Convert convergence to shear (forward model).
    """
    # Fourier transform
    kappa_k = fft2(kappa)
    
    # Wave vectors
    n_pixels = len(ra_grid)
    kx = fftfreq(n_pixels) * 2 * np.pi
    ky = fftfreq(n_pixels) * 2 * np.pi
    kx_grid, ky_grid = np.meshgrid(kx, ky)
    k2 = kx_grid**2 + ky_grid**2
    k2[0, 0] = 1
    
    # Shear from convergence
    gamma1_k = (kx_grid**2 - ky_grid**2) / k2 * kappa_k
    gamma2_k = 2 * kx_grid * ky_grid / k2 * kappa_k
    
    # Inverse transform
    gamma1 = ifft2(gamma1_k).real
    gamma2 = ifft2(gamma2_k).real
    
    return gamma1, gamma2

# Predict shear from reconstructed mass
gamma1_pred, gamma2_pred = convergence_to_shear(kappa, ra_grid, dec_grid)

# Interpolate to galaxy positions
from scipy.interpolate import RectBivariateSpline

interp_gamma1 = RectBivariateSpline(dec_grid, ra_grid, gamma1_pred)
interp_gamma2 = RectBivariateSpline(dec_grid, ra_grid, gamma2_pred)

e1_pred = interp_gamma1(dec, ra, grid=False)
e2_pred = interp_gamma2(dec, ra, grid=False)

# Compute residuals
residual_e1 = e1 - e1_pred
residual_e2 = e2 - e2_pred

# Chi-squared
chi2_standard = np.sum(weight * (residual_e1**2 + residual_e2**2))
dof = len(e1) - 1  # Degrees of freedom
reduced_chi2 = chi2_standard / dof

print(f"Standard fit:")
print(f"  χ² = {chi2_standard:.2e}")
print(f"  Reduced χ² = {reduced_chi2:.4f}")
print(f"  RMS residual = {np.sqrt(np.mean(residual_e1**2 + residual_e2**2)):.6f}")
```

---

## Week 2: Implement Grain Basis

### Define Grain Kernels

```python
def grain_kernel(ra, dec, center_ra, center_dec, normal_angle, 
                 width=10.0, thickness=1.0):
    """
    Planar slab kernel for a single grain.
    
    Parameters:
    - ra, dec: grid coordinates (degrees)
    - center_ra, center_dec: grain center (degrees)
    - normal_angle: grain orientation (degrees, 0-180)
    - width: grain width (arcmin)
    - thickness: grain thickness (arcmin)
    
    Returns:
    - kernel: 2D array of grain profile
    """
    # Convert to arcmin
    ra_arcmin = (ra - center_ra) * 60
    dec_arcmin = (dec - center_dec) * 60
    
    # Normal vector
    theta = normal_angle * np.pi / 180
    nx = np.cos(theta)
    ny = np.sin(theta)
    
    # Distance along and perpendicular to normal
    d_perp = ra_arcmin * nx + dec_arcmin * ny
    d_para = np.sqrt(ra_arcmin**2 + dec_arcmin**2 - d_perp**2)
    
    # Slab profile (Gaussian)
    kernel = np.exp(-d_perp**2 / (2 * thickness**2)) * \
             np.exp(-d_para**2 / (2 * width**2))
    
    # Normalize
    kernel /= np.sum(kernel)
    
    return kernel

# Create grain basis
n_grains = 15
grain_angles = np.linspace(0, 180, n_grains, endpoint=False)

# Center of survey
center_ra = np.mean(ra)
center_dec = np.mean(dec)

# Generate basis
grain_basis = []
for angle in grain_angles:
    kernel = grain_kernel(ra_grid[:, None], dec_grid[None, :],
                         center_ra, center_dec, angle)
    grain_basis.append(kernel)

print(f"Created {len(grain_basis)} grain kernels")

# Visualize first few grains
fig, axes = plt.subplots(2, 3, figsize=(15, 10))
for i, ax in enumerate(axes.flat):
    if i < len(grain_basis):
        ax.imshow(grain_basis[i], cmap='viridis')
        ax.set_title(f'Grain {i+1} (θ = {grain_angles[i]:.1f}°)')
        ax.axis('off')
plt.tight_layout()
plt.savefig('grain_basis.png', dpi=150)
plt.show()
```

---

## Week 3-4: Fit with Grains

### Optimize Grain Amplitudes

```python
from scipy.optimize import minimize

def fit_with_grains(e1, e2, ra, dec, weight, kappa_init, grain_basis):
    """
    Fit shear with standard mass + grain components.
    """
    def objective(alpha):
        # Add grain contributions to convergence
        kappa_grains = np.sum([alpha[i] * grain_basis[i] 
                               for i in range(len(alpha))], axis=0)
        
        kappa_total = kappa_init + kappa_grains
        
        # Predict shear
        gamma1_pred, gamma2_pred = convergence_to_shear(
            kappa_total, ra_grid, dec_grid
        )
        
        # Interpolate to galaxy positions
        interp_g1 = RectBivariateSpline(dec_grid, ra_grid, gamma1_pred)
        interp_g2 = RectBivariateSpline(dec_grid, ra_grid, gamma2_pred)
        
        e1_pred = interp_g1(dec, ra, grid=False)
        e2_pred = interp_g2(dec, ra, grid=False)
        
        # Chi-squared
        chi2 = np.sum(weight * ((e1 - e1_pred)**2 + (e2 - e2_pred)**2))
        
        return chi2
    
    # Initial guess: zero grain amplitudes
    alpha_init = np.zeros(len(grain_basis))
    
    # Optimize
    print("Optimizing grain amplitudes...")
    result = minimize(objective, alpha_init, method='L-BFGS-B',
                     options={'maxiter': 100, 'disp': True})
    
    return result.x, result.fun

# Run optimization
alpha_opt, chi2_grains = fit_with_grains(
    e1, e2, ra, dec, weight, kappa, grain_basis
)

# Compare
improvement = (chi2_standard - chi2_grains) / chi2_standard * 100

print(f"\nResults:")
print(f"  Standard χ² = {chi2_standard:.2e}")
print(f"  Grain-enhanced χ² = {chi2_grains:.2e}")
print(f"  Improvement = {improvement:.2f}%")

# Plot grain amplitudes
plt.figure(figsize=(10, 6))
plt.bar(range(len(alpha_opt)), alpha_opt)
plt.xlabel('Grain Index')
plt.ylabel('Amplitude')
plt.title('Optimized Grain Amplitudes')
plt.savefig('grain_amplitudes.png', dpi=150)
plt.show()
```

---

## Week 5: Statistical Significance

### Bootstrap Analysis

```python
def bootstrap_significance(e1, e2, ra, dec, weight, kappa, grain_basis,
                          n_bootstrap=100):
    """
    Assess significance via bootstrap resampling.
    """
    improvements = []
    
    for i in range(n_bootstrap):
        print(f"Bootstrap {i+1}/{n_bootstrap}")
        
        # Resample galaxies
        idx = np.random.choice(len(e1), len(e1), replace=True)
        e1_boot = e1[idx]
        e2_boot = e2[idx]
        ra_boot = ra[idx]
        dec_boot = dec[idx]
        weight_boot = weight[idx]
        
        # Standard fit
        kappa_boot, _, _ = kaiser_squires(e1_boot, e2_boot, ra_boot, dec_boot)
        gamma1_std, gamma2_std = convergence_to_shear(kappa_boot, ra_grid, dec_grid)
        
        # ... (interpolate and compute chi2_std)
        
        # Grain fit
        alpha_boot, chi2_grain_boot = fit_with_grains(
            e1_boot, e2_boot, ra_boot, dec_boot, weight_boot,
            kappa_boot, grain_basis
        )
        
        # Improvement
        imp = (chi2_std_boot - chi2_grain_boot) / chi2_std_boot
        improvements.append(imp)
    
    return np.array(improvements)

# Run bootstrap
improvements = bootstrap_significance(e1, e2, ra, dec, weight, kappa, grain_basis)

# Statistics
mean_imp = np.mean(improvements) * 100
std_imp = np.std(improvements) * 100
significance = mean_imp / std_imp

print(f"\nBootstrap Results:")
print(f"  Mean improvement: {mean_imp:.2f}% ± {std_imp:.2f}%")
print(f"  Significance: {significance:.2f} σ")

# Plot distribution
plt.figure(figsize=(10, 6))
plt.hist(improvements * 100, bins=30, alpha=0.7, edgecolor='black')
plt.axvline(mean_imp, color='r', linestyle='--', label=f'Mean = {mean_imp:.2f}%')
plt.xlabel('Improvement (%)')
plt.ylabel('Count')
plt.title(f'Bootstrap Distribution (n={len(improvements)})')
plt.legend()
plt.savefig('bootstrap_distribution.png', dpi=150)
plt.show()
```

---

## Expected Timeline

| Day | Task | Output |
|-----|------|--------|
| 1 | Setup + data access | Registered, installed |
| 2-3 | Load + explore | Data quality plots |
| 4-7 | Standard fit | Baseline χ², residuals |
| 8-14 | Grain basis | Kernel functions |
| 15-28 | Grain fit | Optimized amplitudes |
| 29-35 | Bootstrap | Significance estimate |

**Total: 5 weeks to first results**

---

## Success Criteria

### Positive Result
- Improvement > 5%
- Significance > 3σ
- Grain orientations physically meaningful

### Null Result
- Improvement < 1%
- Significance < 2σ
- Random grain orientations

---

## Next Steps After Test 1

If positive:
1. Repeat with DES/HSC (larger datasets)
2. Move to Test 2 (filament stacking)
3. Write paper

If null:
1. Try different grain scales
2. Check for systematics
3. Refine theory

---

## Get Started NOW

```bash
# Clone this repo
git clone https://github.com/yourusername/Kantian-IVI.git
cd Kantian-IVI

# Run setup script
python scripts/test1_setup.py

# Start analysis
python scripts/test1_analysis.py
```

**The data is public. The tools are ready. Let's test it!** 🚀
