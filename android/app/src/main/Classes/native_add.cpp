//
// Created by Administrator on 2023/4/4.
//

#include <stdint.h>
#include "native_add.h"
#include <stdlib.h>


int32_t native_add(int32_t x, int32_t y) {
    int count = 1;
    for(int i = 1;i<1000000000;i++){
        count = count * i;
    }
    return x + y;
}

struct Coordinate *create_coordinate(double latitude, double longitude)
{
    struct Coordinate *coordinate = (struct Coordinate *)malloc(sizeof(struct Coordinate));
    coordinate->latitude = latitude;
    coordinate->longitude = longitude;
    return coordinate;
}

int Test::testRes(int para){
    return para+4;
}

int getText(int param){
    int res = Test().testRes(param);
    return res;
}

