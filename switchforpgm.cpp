#include<iostream>
using namespace std;
int main()
{

	int button=2;
	int a=3;
	a = 2 + a;
	int b = (2 + a) *7;
	int c = a;
	int i = 6;
	
	switch(button)
	{
		case 1:
			b=2;
			for(int j =0;j<a;j=j+1)
			{
				int sum= i * 2 + j;
				c = j;
			}
			break;
 		case 2:
			int d=1;
			break;
		case 3:
			a=1;
			break;
		case 4:
			int k = 1;
			break;
		default:
			int y = 7;
			break;
	}
	return 0;
}
