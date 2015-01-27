## These functions do two things. The first is a function that caches the inverse of a square matrix.
# If the matrix is not a square matrix, a NULL value will be returned for the inverse
# The second is a function that checks if the inverse is cached and if it is, returns it. If not, then
# calculates it and returns it

## makeCacheMatrix takes a matrix as it's input and then has two functions in it.
## The first is doinverse, which caches the inverse
## The second is getinverse, which returns the cached inverse

makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    issquare <<- nrow(x)==ncol(x)
    doinverse<-function() {
        inv <<- NULL
        if(issquare){
        inv <<- solve(x)
        }
    }
    
    getinverse<-function() inv
    
    list( issquare, doinverse = doinverse, getinverse = getinverse)
}


## This function checks to see if the inverse of the object exists. If not,
## then it runs doinverse. If it does exist, then it just gets the inverse

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    ## first test to see if getinverse() in the previous returns a null values
    if (is.null(x$getinverse())) {
        x$doinverse()
    }
    inv<-x$getinverse()
}
