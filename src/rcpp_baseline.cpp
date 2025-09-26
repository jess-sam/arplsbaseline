#include <RcppArmadillo.h>
#include <algorithm>
using namespace std;
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]

arma::vec rcpp_baseline(const NumericVector &y_vec, 
                        const double &lambda, const double &ratio) {
  
  auto start = chrono::high_resolution_clock::now();
  
  int N = y_vec.size();
  arma::vec y(as<arma::vec>(y_vec));
  
  arma::sp_mat D(N-2, N);
  
  for(int i = 0; i < N - 2; i++){
    D(i, i) = 1.0;
    D(i, i + 1) = -2.0;
    D(i, i + 2) = 1.0;
  }
  
  arma::sp_mat H(lambda * D.t() * D);
  arma::vec w(arma::ones(N));
  arma::vec z(w);
  
  int iters = 1;
  
  while(iters < 150){
    
    arma::mat W(N, N, arma::fill::zeros);
    W.diag() = w;
    
    arma::mat C(arma::chol(W + H));
    z = arma::solve(C, arma::solve(C.t(), (w % y)));

    arma::vec d(y-z);
    arma::uvec ids(arma::find(d < 0)); // Find indices
    arma::vec d_minus(d.elem(ids));       // Assign value to condition
    
    double m = 0.0;
    double std = 0.0;
    
    if (d_minus.size() > 0) {
      m = arma::mean(d_minus);
      std = arma::stddev(d_minus);
    }
    
    arma::mat wt(1 /(1 + arma::exp(2 * (d-(2*std-m))/std)));
    
    if(norm(w - wt)/norm(w) < ratio){
      break;
    }
    
    w = wt;
    iters++;
  }
  
  auto end = chrono::high_resolution_clock::now();
  std::chrono::duration<double> time = end - start;
  
  Rcout << "Baseline Computation Time (seconds) = " << time.count() << "\n";
  Rprintf("Iterations = %d\n", iters);
  
  if(iters == 150){
    Rprintf("Max iterations of the algorithm reached.\n");
    
  }
  
  return z;
}
