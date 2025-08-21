
#include <Rcpp.h>
#include <algorithm>
using namespace std;
using namespace Rcpp;


// [[Rcpp::export]]
double rcpp_baseline(NumericVector y, double lambda, double ratio) {
  int N = y.size();
  
  NumericMatrix D(N - 2, N);
  
  for(int i = 0; i < N - 2; i++){
    D(i, i) = 1.0;
    D(i, i + 1) = -2.0;
    D(i, i + 2) = 1.0;
  }
  
  print(D);
  return N;
}