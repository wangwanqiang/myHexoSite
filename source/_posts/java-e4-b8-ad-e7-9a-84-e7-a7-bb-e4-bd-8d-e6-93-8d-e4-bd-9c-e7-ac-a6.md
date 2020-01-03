---
title: Java中的移位操作符
url: 278.html
id: 278
date: 2018-04-29 11:09:22
tags:
---

java中有三种移位运算符

> *   << : 左移运算符，num << 1,相当于num乘以2
> *   >\> : 右移运算符，num >> 1,相当于num除以2
> *   >>\> : 无符号右移，忽略符号位，空位都以0补齐

下面是测试代码`public static void main(String[] args) {
        int number = 10;
        //原始数二进制
        printInfo(number);
        number = number << 1;
        //左移一位
        printInfo(number);
        number = number >> 1;
        //右移一位
        printInfo(number);
    }
    
    /**
     * 输出一个int的二进制数
     * @param num
     */
    private static void printInfo(int num){
        System.out.println(Integer.toBinaryString(num));
    }` 输出结果： 1010 10100 1010