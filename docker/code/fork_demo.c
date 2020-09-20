#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
 
 
int main(int argc,char *argv[])
{
	// 创建两个进程类型的变量
	pid_t pid1,pid2;
	
	// 通过系统调用fork派生一个子进程，对于父进程来说，返回的是子进程的PID。
	// 对于子进程来说，返回的是0, 所以下面那段打印“子进程1”这行代码是在子进程中执行的。
	pid1 = fork();
	if(pid1<0)
	{
		printf("创建进程失败!");
		exit(1);
	}
	// 在子进程中直接这段代码
	else if(pid1==0)
	{
		printf("子进程1,进程标识符是%d\n",getpid());
	}
	else
	// 在父进程中执行这段代码	
	{
		pid2 = fork();
		if(pid2<0)
		{
			printf("创建进程失败!");
			exit(1);
		}
		else if(pid2==0)
		{
			printf("子进程2,进程标识符是%d\n",getpid());
		}
		else
		{
			printf("父进程,进程标识符是%d\n",getpid());
		}
	}
	return 0;
}
