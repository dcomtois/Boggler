#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List cpp_str_split( std::vector< std::string > strings, int n ) {

  int num_strings = strings.size();

  List out(num_strings);

  for( int i=0; i < num_strings; i++ ) {

    int num_substr = strings[i].length() / n;
    std::vector< std::string > tmp;

    for( int j=0; j < num_substr; j++ ) {

      tmp.push_back( strings[i].substr( j*n, n ) );

    }

    out[i] = tmp;

  }

  return out;
}
