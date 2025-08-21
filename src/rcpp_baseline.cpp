#include <RcppArmadillo.h>
#include <algorithm>
using namespace std;
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]

double rcpp_baseline(NumericVector y, double lambda, double ratio) {
  int N = y.size();
  
  NumericMatrix D(N - 2, N);
  
  for(int i = 0; i < N - 2; i++){
    D(i, i) = 1.0;
    D(i, i + 1) = -2.0;
    D(i, i + 2) = 1.0;
  }
  
  arma::mat D_arma(D.begin(), D.nrow(), D.ncol());
  arma:: mat H = lambda * D_arma.t() * D_arma;
  arma::vec w = arma::ones(N);
  
  Rcout << "H:\n" << H << "\n";
  Rcout << "w:\n" << w << "\n";
  
  return N;
}

