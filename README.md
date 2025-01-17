<!-- badges: start -->
[![R-CMD-check](https://github.com/ericdunipace/RcppCGAL/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ericdunipace/RcppCGAL/actions/workflows/R-CMD-check.yaml)
 [![](https://www.r-pkg.org/badges/version/RcppCGAL)](https://www.r-pkg.org/pkg/RcppCGAL)
<!-- badges: end -->
  
## RcppCGAL: CGAL Headers for R


### Description

This package provides access to the Computational Geometry Algorithms Library 
([CGAL](https://www.cgal.org)) in [R](https://www.r-project.org).  
[CGAL](https://www.cgal.org) provides access to methods like KDtree, Hilbert sorting, 
convex hull calculation, and many more.

This package allows for the easy linking of the CGAL header files into R packages without having to 
download and manually add the appropriate CGAL header file into an R package.

Much like the `BH` package, the `RcppCGAL` package can be used via the `LinkingTo:` 
field in the `DESCRIPTION` file in R packages. This will allow access to the header files in C/C++ source code.

### Version
This package currently bundles the 6.0.1 stable release.

### Other versions
It's important to note that the version number of the package roughly corresponds (as best I'm able to) with the version of the CGAL header files.

This can be important to make note of as future versions of the CGAL header files may cause breaking changes in your packages. This last happened with the switch from 5.x to 6.x when the flag for ignoring GMP changed!

### Installation
To install this package, you can install the version from CRAN:
```R
install.packages("RcppCGAL")
```

Alternatively, you can download or clone the git repository. Then you can install using devtools
```R
devtools::install("RcppCGAL")
```
You may also install from github directly using the
`devtools::install_github()` function.

By default, the package will use the header files bundled with the package. However,
if you already have a version of the CGAL headers that you prefer to use,
you can specify the environmental variable `CGAL_DIR` and `R` will use that
instead:
```R
Sys.setenv("CGAL_DIR" = "path/to/CGAL")
```
or, if the function is already installed, you can use the `set_cgal()` function in the package
```R
set_cgal("path/to/CGAL")
```
and then re-install.

Typically, the folder with all the header files is called `CGAL`. 
For example, on my Mac with a Homebrew install of CGAL, I would do
```R
Sys.setenv("CGAL_DIR" = "/usr/local/Cellar/cgal/5.6/include/CGAL")
```
Note: this must be done *before* the package is installed by `R`.

### Example
We provide an example of how to perform Hilbert sorting using an `R` matrix:

```c++
// [[Rcpp::depends(RcppCGAL)]]
// [[Rcpp::depends(BH)]]
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::plugins(cpp14)]]  

#include <RcppEigen.h>
#include <CGAL/basic.h>
#include <CGAL/Cartesian_d.h>
#include <CGAL/spatial_sort.h>
#include <CGAL/Spatial_sort_traits_adapter_d.h>
#include <CGAL/boost/iterator/counting_iterator.hpp>
#include <CGAL/hilbert_sort.h>
#include <CGAL/Spatial_sort_traits_adapter_d.h>

typedef CGAL::Cartesian_d<double>           Kernel;
typedef Kernel::Point_d                     Point_d;

typedef CGAL::Spatial_sort_traits_adapter_d<Kernel, Point_d*>   Search_traits_d;

void hilbert_sort_cgal_fun(const double * A, int D, int N,  int * idx)
{
  
  std::vector<Point_d> v;
  double * temp = new double[D];
  
  for (int n = 0; n < N; n++ ) {
    for (int d = 0; d < D; d ++) {
      temp[d] = A[D * n + d];
    }
    v.push_back(Point_d(D, temp, temp+D));
  }
  
  std::vector<std::ptrdiff_t> temp_index;
  temp_index.reserve(v.size());
  
  std::copy(
    boost::counting_iterator<std::ptrdiff_t>(0),
    boost::counting_iterator<std::ptrdiff_t>(v.size()),
    std::back_inserter(temp_index) );
  
  CGAL::hilbert_sort (temp_index.begin(), temp_index.end(), Search_traits_d( &(v[0]) ) ) ;
  
  for (int n = 0; n < N; n++) {
    idx[n] = temp_index[n];
  }
  
  delete [] temp;
  temp=NULL;
}

// [[Rcpp::export]]
Rcpp::IntegerVector hilbertSort(const Eigen::MatrixXd & A)
{
  int K = A.rows();
  int N = A.cols();
  std::vector<int> idx(N);
  
  hilbert_sort_cgal_fun(A.data(), K, N, &idx[0] );
  return(Rcpp::wrap(idx));
}
```

Saving this code as `hilbertSort.cpp` and sourcing with Rcpp `Rcpp::sourceCpp("hilbertSort.cpp")`
makes the function `hilbertSort()`. Be aware that this example 
function example assumes that the observations are stored by
column rather than by row, that is as the transpose of the 
usual `R` `matrix` or `data.frame`.

### Author

Eric Dunipace

## License
This package is provided under the GPL-3. For the use of the header files outside this package, please see the information at the CGAL site: [https://www.cgal.org/license.html](https://www.cgal.org/license.html)

