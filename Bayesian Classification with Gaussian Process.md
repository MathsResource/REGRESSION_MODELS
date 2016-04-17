Bayesian Classification with Gaussian Process

Despite prowess of the support vector machine, it is not specifically designed to extract features relevant to the prediction. For example, in network intrusion detection, we need to learn relevant network statistics for the network defense. In consumer credit rating, we would like to determine relevant financial records for the credit score. As for medical genetics research, we aim to identify genes relevant to the illness.

Bayesian learning has the Automatic Relevance Determination (ARD) capability built-in for this purpose. A particularly effective implementation is the variational Bayes approximation algorithm adopted in the R package vbmp. Using a Gaussian process prior on the function space, it is able to predict the posterior probability much more economically than plain MCMC.

Example 1
For illustration, we begin with a toy example based on the rvbm.sample.train data set in rpud. The data set has two components, namely X and t.class. The first component X contains data points in a six dimensional Euclidean space, and the second component t.class classifies the data points of X into 3 different categories according to the squared sum of the first two coordinates of the data points. The other four coordinates in X serve only as noise dimensions. It is created with R code in the vbmp vignette.

We can visualize the data set is in a scatter plot as follows. The innermost layer is plotted in green triangles, the middle one is in blue solid dots, and the outermost layer is in red hollow dots.

> library(rpud) 
> x1 <− rvbm.sample.train$X[, 1] 
> x2 <− rvbm.sample.train$X[, 2] 
> tc <− rvbm.sample.train$t.class 
 
> plot(x1, x2, type="n", xlab="X1", ylab="X2") 
> points(x1[tc==1], x2[tc==1], type="p", col="blue", pch=19) 
> points(x1[tc==2], x2[tc==2], type="p", col="red") 
> points(x1[tc==3], x2[tc==3], type="p", col="green", pch=24)
PIC

We will perform Gaussian process classification with the data set using the vbmp package. As it is in the Bioconductor repository, we have to install it with the biocLite remote script.

> source("http://bioconductor.org/biocLite.R") 
> biocLite("vbmp")
Then we apply the vmbp method with the bThetaEstimate option for Automatic Relevance Determination. The training process takes about 200 seconds on an AMD X4 CPU.

> library(vbmp) 
> system.time(res.vbmp <− vbmp( 
+   rvbm.sample.train$X, 
+   rvbm.sample.train$t.class, 
+   rvbm.sample.test$X, 
+   rvbm.sample.test$t.class, 
+   theta = rep(1., ncol(rvbm.sample.train$X)), 
+   control = list( 
+     sKernelType="gauss", 
+     bThetaEstimate=TRUE, 
+     bMonitor=TRUE, 
+     InfoLevel=1) 
+   )) 
      ...... 
  user  system elapsed 
196.70    0.04  196.80
We then print out the covariance parameters with the covParams method, and note that the first two parameters are less than one, while the rest are all much larger than one. It thus indicates that only the first two parameters are relevant.

> covParams(res.vbmp) 
[1] 1.979e−01 8.338e−02 3.009e+03 1.814e+03 
[5] 2.245e+03 1.931e+03
Applying the predError method in vbmp, we found the error ratio to be 3.8%. Similarly, the predLik method shows that the posterior log likelihood is -0.3483.

> predError(res.vbmp) 
[1] 0.038 
 
> predLik(res.vbmp) 
[1] −0.3483
We can run the same training process in much shorter time with the rvbm method in the rpudplus package. It takes about 20 seconds on an NVIDIA GTX 460 GPU.

> library(rpud)     # load rpudplus 
> system.time(res.rvbm <− rvbm( 
+   rvbm.sample.train$X, rvbm.sample.train$t.class, 
+   rvbm.sample.test$X, rvbm.sample.test$t.class, 
+   theta = rep(1., ncol(rvbm.sample.train$X)), 
+   control = list( 
+     sKernelType="gauss", 
+     bThetaEstimate=TRUE, 
+     bMonitor=TRUE, 
+     InfoLevel=1) 
+ )) 
     ...... 
   user  system elapsed 
 19.693   0.208  19.844 
 
> summary(res.rvbm) 
     ...... 
 
Covariance kernel hyperparameters: 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      0     459    2020    1650    2440    3320 
 
Posterior log likelihood:  −0.351 
Prediction error rate:     3.8 % 
 
> summary(model.rvbm)$covParams 
[1] 2.073e−01 8.103e−02 3.324e+03 2.197e+03 
[5] 2.517e+03 1.835e+03
Example 2
A more practical example is the BRCA12 data set in vmbp. It contains the genetic test results of 30 cancer patients. Because of its large feature space with 8,080 genes and small sample size of 30, determining relevant genes is difficult with the support vector machine. With Bayesian methods, we do not have such constraint.

Let us load the data set into the workspace.

> library(vbmp) 
> data(BRCA12)
As the data set is in the Bioconductor format, we need to install the Biobase package in order to extract the gene expression values. We then save the values in a new matrix brca.x. The matrix has 30 rows, each containing 8,080 gene expression values of a patient.

> source("http://bioconductor.org/biocLite.R") 
> biocLite("Biobase") 
 
> library(Biobase) 
> brca.x <− t(exprs(BRCA12))
Next, we save the individual case categories of the patients in a vector brca.y.

> brca.y <− BRCA12$Target.class
Then we apply the rvbm method in rpudplus for the Gaussian process classification. Since the data lies in a high-dimensional Euclidean space, a linear kernel, instead of the usual Gaussian one, is more appropriate. On an GTX 460 GPU, the task takes about 2 minutes and a half to finish. Performing similar task with vbmp using the equivalent iprod kernel would take hours.

> library(rpud)     # load rpudplus 
> system.time(brca.rvbm <− rvbm( 
+   brca.x, brca.y, 
+   brca.x, brca.y, 
+   theta = rep(1.0, ncol(brca.x)), 
+   control=list( 
+     sKernelType="linear", 
+     bThetaEstimate=TRUE, 
+     bMonitor=TRUE, 
+     InfoLevel=1) 
+ )) 
     ...... 
   user  system elapsed 
148.562   3.656 152.205
The following indicates no extreme value in the kernel parameters, and confirms that all genes in the BRCA12 data set are relevant in the study. The summary also shows that the posterior log likelihood is -0.0338, and the prediction error rate is zero.

> summary(brca.rvbm) 
     ...... 
 
Covariance kernel hyperparameters: 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.391   0.839   0.978   1.000   1.140   2.390 
 
Posterior log likelihood:  −0.03392 
Prediction error rate:     0 %
Lastly we can plot the training history, and visually check the convergence of the lower bound estimate of marginal likelihood.

> plot(brca.rvbm)
PIC

References
Zoubin Ghahramani: A Tutorial on Gaussian Processes. (or Why I Don’t Use SVMs) URL http://mlss2011.comp.nus.edu.sg/uploads/Site/lect1gp.pdf
Mark Girolami and Simon Rogers: Variational Bayesian Multinomial Probit Regression with Gaussian Process Priors. Neural Computation, 18:1790–1817, 2006.
Zsofia Kote-Jarai, et al: Accurate Prediction of BRCA1 and BRCA2 Heterozygous Genotype Using Expression Profiling After Induced DNA Damage. Clinical Cancer Research, 12 (13):3896–3901, Jul 2006.
Nicola Lama and Mark Girolami: Variational Bayesian Multinomial Probit Regression for Gaussian Process Multi-class Classification. URL http://www.bioconductor.org/packages/release/bioc/html/vbmp.html
