//
// Created by Administrator on 2023/4/4.
//

#ifndef TESTFFI_NATIVE_ADD_H
#define TESTFFI_NATIVE_ADD_H


//#include <stdio.h>
//#include <stdlib.h>
//#include <string>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y);




struct Coordinate
{
    double latitude;
    double longitude;
};

extern "C" __attribute__((visibility("default"))) __attribute__((used))
struct Coordinate *create_coordinate(double latitude, double longitude);


class Test {
public:
	int testRes(int para);
};

typedef void (*callback) (int);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int getText(int para);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
intptr_t ffi_Dart_InitializeApiDL(void* data);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int native_add_callback(int x,int y,callback call);

#endif //TESTFFI_NATIVE_ADD_H
