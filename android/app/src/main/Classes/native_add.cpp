//
// Created by Administrator on 2023/4/4.
//

#include <stdint.h>
#include "native_add.h"
#include <stdlib.h>
#include <android/log.h>
#include "dart_api_dl.h"
#include <pthread.h>
#include "future"


#define  LOGD(...) __android_log_print(ANDROID_LOG_DEBUG,"Debug" ,__VA_ARGS__)

int i = 0;

int32_t native_add(int32_t x, int32_t y) {
    int count = 1;
    for (int i = 1; i < 2000000000; i++) {
        count = count * i;
    }
    i++;
    LOGD("nativa_add c load value %d", i);
    return x + y;
}

struct Coordinate *create_coordinate(double latitude, double longitude) {
    struct Coordinate *coordinate = (struct Coordinate *) malloc(sizeof(struct Coordinate));
    coordinate->latitude = latitude;
    coordinate->longitude = longitude;
    return coordinate;
}

int Test::testRes(int para) {
    return para + 4;
}

int getText(int param) {
    int res = Test().testRes(param);
    return res;
}

intptr_t ffi_Dart_InitializeApiDL(void *data) {
    return Dart_InitializeApiDL(data);
}

struct Param {
    int x;
    int y;
    callback call;
};

void *native_add_thread(void *para) {
    Param *ps = (Param *) para;
    int count = 1;
    for (int i = 1; i < 1000000000; i++) {
        count = count * i;
    }
    i++;
    ps->call(22);
    return reinterpret_cast<void *>(ps->x + ps->y);
}

int native_add_callback(int x, int y, callback call) {
    pthread_t handles; // 线程句柄
    Param param;
    param.x = x;
    param.y = y;
    param.call = call;
    int result = pthread_create(&handles,NULL,native_add_thread,&param);
    /*
    std::future<int> ans = std::async(
            [x,y]()->int{
                int count = 1;
                for (int i = 1; i < 1000000000; i++) {
                    count = count * i;
                }
                i++;
                return x+y;
            }
            );
            int result = ans.get();
    call(result);
    */
    call(321);
    return result;
}

