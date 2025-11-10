#include <iostream>
#include <cstdio>
#include <cstdint>

extern "C" int sum(int a, int b){
    return  (a+b) & 0xFF;
}