#include <RcppArmadillo.h>
#include <algorithm>
using namespace std;
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]

double rcpp_baseline(NumericVector y_vec, double lambda, double ratio) {
  int N = y_vec.size();
  arma::vec y = as<arma::vec>(y_vec);
  
  NumericMatrix D(N - 2, N);
  
  for(int i = 0; i < N - 2; i++){
    D(i, i) = 1.0;
    D(i, i + 1) = -2.0;
    D(i, i + 2) = 1.0;
  }
  
  arma::mat D_arma(D.begin(), D.nrow(), D.ncol());
  arma:: mat H = lambda * D_arma.t() * D_arma;
  arma::vec w = arma::ones(N);
  
  arma::mat W(N, N, arma::fill::zeros);
  W.diag() = w;
  
  arma:: mat C = arma::chol(W + H);
  arma::vec z = arma::solve(C, arma::solve(C.t(), (w % y)));
  
  arma::vec d = y-z;
  
  return N;
}

