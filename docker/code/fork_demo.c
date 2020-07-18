#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
 
 
int main(int argc,char *argv[])
{
	pid_t pid1,pid2;
	pid1 = fork();
	if(pid1<0)
	{
		printf("创建进程失败!");
		exit(1);
	}
	else if(pid1==0)
	{
		printf("子进程1,进程标识符是%d\n",getpid());
	}
	else
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
