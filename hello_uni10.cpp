#include <iostream>
#include <random>
#include <algorithm>
#include <uni10.hpp>

using namespace std;

int main(){

    int dim = 2;
    // set dimension of bond
    uni10::Bond leg_1(uni10::BD_IN, dim);
    uni10::Bond leg_2(uni10::BD_OUT, dim);
    vector<uni10::Bond> bond;
    bond.push_back(leg_1); bond.push_back(leg_2);
    
    // create uniTensor
    uni10::UniTensor<double> A(bond);
    uni10::UniTensor<double> B(bond);

    // random Matrix
    uni10::Matrix<double> M;
    M.Assign(dim, dim);
    M.Randomize();
    //cout << M << endl;

    // put elements to A and B 
    A.PutBlock(M);

    M.Randomize();
    B.PutBlock(M);

    cout << A << endl;
    cout << B << endl;

    // tensor product
    cout << uni10::Otimes(A, B) << endl;

    // contraction
    A.SetLabel({1, -1});
    B.SetLabel({-1, 2});
 
    cout << A << endl;
    cout << B << endl;

    uni10::UniTensor<double> C =  uni10::Contract(A, B);
    
    cout << C << endl;

    // contraction with network
    uni10::UniTensor<double> H;
    uni10::Network network("file.net");
    network.PutTensor("A", A);
    network.PutTensor("B", B);
    network.Launch(H);

    cout << H << endl;
    return 0;
}
