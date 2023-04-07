package com.example.testffi;

public class Jni {

    static {
        System.loadLibrary("method_channel");
    }

    static public native void setJniRef(Object cls);
    static public native void emitMsg(int cls);
    static public native int nativeAdd(int x,int y);


    //static public native int runNetNT(String initNTImgPath);
}
