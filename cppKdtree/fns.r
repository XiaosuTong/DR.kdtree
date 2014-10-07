

##################################################
# function cppkdtree
#	call c++ library to create kdtree
##################################################


## notes:
## 1. "src/aa_cppkdtree.cpp" is the cpp program
## 2. "src/aa_auto_compile" is the code to compile and clean up
## 3. "src/aa_kdtree.R" is a wrapper in R
## 4. run "src/aa_auto_compile", then dynamic load the .so file
## dyn.load("./src/cppkdtree.so")

cppkdtree <- function(data, nb)  ## data matrix, no.of.leaves
{
        D <- ncol(data)  ## number of columns in dm
        ND <- nrow(data)  ## number of rows in dm
        bucketSize <- ND/nb  ## number of rows in each leaf
        ## void getkdtree(double *data, int *D, int *ND, int *bucketSize, int* pidx, int *owner)
        res <- .C("getkdtree"
                , as.numeric(data)  ## data matrix as a vector, by column first
                , as.integer(D)  ## number of columns in dm
                , as.integer(ND)  ## number of rows in dm
                , as.integer(bucketSize)  ## number of rows in each leaf
                , idx = integer(ND)  ## pre-allocate index of rows
                , leaf = integer(ND)  ## pre-allocate leaf
        )
        ## res is a list of 6 elements:
        ## 1. dm as a vector
        ## 2. number of columns in dm
        ## 3. number of rows in dm
        ## 4. number of rows in each leaf
        ## 5. index of rows
        ## 6. index of leaves, can be matched up with index of rows to find leaves
	## output index of rows and index of leaves
        return(data.frame(idx=res[[5]], leaf=res[[6]]))
}

## notes on how to compile cppkdtree
## in R, set the working dir to be cppKdtree/src
#setwd('cppKdtree/src')
#system("./aa_auto_compile")

