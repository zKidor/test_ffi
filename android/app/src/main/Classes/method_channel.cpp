//
// Created by Administrator on 2023/4/4.
//
#include <jni.h>
#include <pthread.h>
#include "native_add.h"

JavaVM *g_jvm = NULL;
jobject g_obj;
pthread_key_t g_key;

void onThreadExit(void *tlsData) {
    JNIEnv *env = (JNIEnv *) tlsData;
    // Do some JNI calls with env if needed ...
    g_jvm->DetachCurrentThread();
}


extern "C"
JNIEXPORT void JNICALL
Java_com_example_testffi_Jni_setJniRef(JNIEnv *env, jclass clazz, jobject cls) {
    // TODO: implement setJniRef()
    env->GetJavaVM(&g_jvm);
    g_obj = env->NewGlobalRef(cls);

    pthread_key_create(&g_key, onThreadExit);
}


extern "C"
JNIEXPORT void JNICALL
Java_com_example_testffi_Jni_emitMsg(JNIEnv *env, jclass clazz, jint p) {
    // TODO: implement emitMsg()
    if (env == NULL || g_obj == NULL)
        return ;
    jclass cls = env->GetObjectClass(g_obj);

    jmethodID method = env->GetMethodID(cls, "emitMsgJava", "(I)I");
    env->CallIntMethod(g_obj, method, p);
}

extern "C"
JNIEXPORT jint JNICALL
Java_com_example_testffi_Jni_nativeAdd(JNIEnv *env, jclass clazz, jint x, jint y) {
    // TODO: implement nativeAdd()
    return native_add(x,y);
}