# Model
目前暂时只支持JSON数据转成Modle  (已添加根据.number声称model代码)

#在什么情况下写的！Model
* 由于自己公司项目中用的是原先protocolbuffer(以下简称PB)是google 的一种数据交换的格式，使用这种数据在传输过程中比JSON数据传输的更小（由于是由于属性只是一个在类中是按顺序生成的，所以可以将json中的key用1、2等int数据代替）！

* PB的Model代码或者其他一些类 是通过一个proto文件生成的！ [PB相关知识](http://www.ibm.com/developerworks/cn/linux/l-cn-gpb/) 

* 但是有个新项目并且是要比较紧急的情况下！而且后台使用PHP,以前PHP同事都是返回JSON数据.

* 但是客户端继续用原来的框架PHP服务端使用JSON数据！使用PB生成的Model类.  

#是使用别人的写好的还是自己写一个？
* 和同事讨论之后知道大致的流程是   NSDic对应一个Model   key  当对应的变量名   Value就是将给成员变量的赋值. 
* 后面就自己写了，写的过程中并和服务端使用的时候除了前一两天会稍微有些细节问题！
#遇到的问题   
* 当一个类是其他的类的一个属性，例如例子当中的Student  是Hostel中的属性studentPbModelLead    采用类名+PbModel+(备注可为空)来处理，同理数组的话studentPbListTotal     采用类名+PbList+(备注可为空)来处理。

* 解决的思想主要是要知道类名和NSDic就可以得到一个Model来处理的  



第一次项目上传写有点啰嗦希望大家见谅，后续会补充两个问题！
========
* 目前需要服务端按照我们定义好的key返回，后续会给每个Model类加上一个服务端返回NSDic 中的key和Model的成员变量名的一个NSDic来匹配.  (已优化)

* 就是写一个根据JSON 或者NSDic 通过生成相关的Model类的代码. (已优化  ps:使用  BuildDemo.number生成对应的 BuildDemo.csv  APP里面解析该字符)








