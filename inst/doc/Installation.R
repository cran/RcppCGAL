## ---- eval = FALSE------------------------------------------------------------
#  install.packages("RcppCGAL")
#  cgal_install(cgal_path = NULL, version = NULL,
#               clean_files = TRUE, force = FALSE)
#  

## ---- eval = FALSE------------------------------------------------------------
#  install.packages("RcppCGAL")
#  cgal_install(cgal_path = NULL, version = "5.5.1",
#               clean_files = TRUE, force = FALSE)
#  

## ---- eval = FALSE------------------------------------------------------------
#  install.packages("RcppCGAL")
#  cgal_install(cgal_path = "path/to/CGAL", version = NULL,
#               clean_files = TRUE, force = FALSE)
#  

## ---- eval = FALSE------------------------------------------------------------
#  install.packages("RcppCGAL")
#  cgal_install(cgal_path = "https://some/url/cgalheaders.tar.gz", version = NULL,
#               clean_files = TRUE, force = FALSE)
#  

## ---- eval = FALSE------------------------------------------------------------
#  Sys.setenv(CGAL_DIR="https://some/url/cgalheaders.tar.gz")

## ---- eval = FALSE------------------------------------------------------------
#  Sys.setenv(CGAL_DOWNLOAD="1")

## ---- eval = FALSE------------------------------------------------------------
#  cgal_install(cgal_path = NULL, version = NULL,
#               clean_files = TRUE, force = TRUE)
#  

