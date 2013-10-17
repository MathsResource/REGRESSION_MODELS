


Dvls = diag(Mat1)		# extract vector of the diagonal elements of 'Mat1'
Dvls

as.matrix(Dvls)			# display the vector in matrix form (3R1C)
t(as.matrix(Dvls)		# transpose of above	(1R3C)

Idty = diag(c(1,1,1))		# create the identity matrix
Idty

Dgnl = diag(diag(Mat1))		# create a 'D' matrix (diagonalization)
Dgnl

Dvls * Idty			# alternative method with scalar multiplication.
				# N.B. Dvls is a vector, not a matrix.


Dgnl.inv = solve(Dgnl)		# invert the D matrix
Dgnl.inv		

Rmdr = Mat1 - Dgnl		# Compute the "Remainder" matrix (elementwise subtraction)


###################


rowMeans(Mat1) 			#Returns vector of row means. 
rowSums(Mat1) 			#Returns vector of row sums.  
colMeans(Mat1) 			#Returns vector of column means.  
colSums(Mat1) 			#Returns vector of coumn means.  

If x and y are matrices then the covariances (or correlations) between the columns of x and the columns of y are computed.

var(Mat1)
 
var(Mat1[,1])
var(Mat1[,2])
var(Mat1[,3])
cov(Mat1[,1],Mat1[,2])
var(Mat1)
VCmat=var(Mat1)
cor(Mat1)
cov2cor(VCmat)
